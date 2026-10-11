// Native V2 HTTP hooks, using the pinned upstream protocol/credential helpers.
// Keep the original body for retries: transforming it twice prefixes tool names twice.
export function createTransport(upstream, fetchImpl = fetch) {
  const pending = new Map()

  async function request(event) {
    const original = event.request
    const url = new URL(original.url)
    // Never send Claude credentials to a configured proxy or unrelated endpoint.
    if (url.origin !== "https://api.anthropic.com" || url.pathname !== "/v1/messages") return
    original.signal.throwIfAborted()
    const creds = await upstream.getCachedCredentials()
      ?? await upstream.getCredentialsWithBackoff({ signal: original.signal })
    if (!creds) {
      throw new Error("Claude Code credentials are unavailable. Run `claude` to sign in or refresh them.")
    }

    const body = await original.clone().text()
    const model = JSON.parse(body).model ?? event.model.id
    const headers = upstream.buildRequestHeaders(
      original, {}, creds.accessToken, model, upstream.getExcludedBetas(model),
    )
    // A transformed body may have a different byte length.
    headers.delete("content-length")
    if (!url.searchParams.has("beta")) url.searchParams.set("beta", "true")
    const init = {
      method: original.method,
      headers,
      body: upstream.transformBody(body),
      signal: original.signal,
    }
    const id = headers.get("x-client-request-id")
    const dispose = () => {
      pending.delete(id)
      original.signal.removeEventListener("abort", dispose)
    }
    original.signal.addEventListener("abort", dispose, { once: true })
    pending.set(id, { url: url.href, init, model, token: creds.accessToken, dispose })
    event.request = new Request(url, init)
    if (original.signal.aborted) dispose()
  }

  async function response(event) {
    const state = pending.get(event.request.headers.get("x-client-request-id"))
    if (!state) return
    state.dispose()
    const { url, init, model } = state
    let token = state.token
    let first = event.response
    // Let upstream's bounded 429/529 backoff inspect the already-received response.
    let result = await upstream.fetchWithRetry(url, init, 3, async (input, options) => {
      if (first) {
        const value = first
        first = undefined
        return value
      }
      return fetchImpl(input, options)
    })

    const retry = async () => {
      init.signal.throwIfAborted()
      await result.body?.cancel()
      const headers = upstream.buildRequestHeaders(
        url, init, token, model, upstream.getExcludedBetas(model),
      )
      // Remove previously rejected beta flags, even if present in the old headers.
      const excluded = upstream.getExcludedBetas(model)
      headers.set("anthropic-beta", (headers.get("anthropic-beta") ?? "")
        .split(",").filter((beta) => !excluded.has(beta.trim())).join(","))
      result = await upstream.fetchWithRetry(url, { ...init, headers }, 3, fetchImpl)
    }

    // Adopt externally rotated tokens before forcing refresh; at most two attempts.
    for (let attempt = 0; result.status === 401 && attempt < 2; attempt++) {
      let creds = upstream.reloadCredentialsFromSource()
      if (!creds || creds.accessToken === token) creds = await upstream.forceRefreshActiveAccount()
      if (!creds || creds.accessToken === token) break
      token = creds.accessToken
      await retry()
    }
    if (result.status === 429) {
      const creds = upstream.reloadCredentialsFromSource()
      if (creds && creds.accessToken !== token) {
        token = creds.accessToken
        await retry()
      }
    }
    for (let attempt = 0; attempt < upstream.LONG_CONTEXT_BETAS.length; attempt++) {
      if (result.status !== 400 && result.status !== 429) break
      if (!upstream.isLongContextError(await result.clone().text())) break
      const beta = upstream.getNextBetaToExclude(model)
      if (!beta) break
      upstream.addExcludedBeta(model, beta)
      token = (await upstream.getCachedCredentials())?.accessToken ?? token
      await retry()
    }
    event.response = result.status === 401 ? result : upstream.transformResponseStream(result)
  }

  return {
    request,
    response,
    dispose() {
      for (const state of pending.values()) state.dispose()
    },
  }
}

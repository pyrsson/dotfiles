import { Plugin } from "@opencode/plugin"
import { loadUpstream } from "../extensions/claude-auth/upstream.js"
import { createTransport } from "../extensions/claude-auth/transport.js"

const methodID = "claude-code"

export default Plugin.define({
  id: "dotfiles.claude-auth",
  async setup(ctx) {
    const upstream = await loadUpstream()
    upstream.initLogger()
    const accounts = upstream.readAllClaudeAccounts()
    upstream.initAccounts(accounts)
    const source = upstream.loadPersistedAccountSource()
    const account = accounts.find((item) => item.source === source) ?? accounts[0]
    if (account) upstream.setActiveAccountSource(account.source)

    const credential = (creds) => ({
      type: "oauth",
      methodID,
      access: creds.accessToken,
      refresh: creds.refreshToken,
      expires: creds.expiresAt,
    })
    await ctx.integration.transform((editor) => {
      editor.method.update({
        integrationID: "anthropic",
        method: {
          id: methodID,
          type: "oauth",
          label: "Use Claude Code credentials",
          ...(accounts.length > 1 ? { form: [{
            type: "string",
            key: "account",
            title: "Claude Code account",
            default: account.source,
            options: accounts.map((item) => ({ value: item.source, label: item.label })),
          }] } : {}),
        },
        async authorize(answer) {
          const latest = upstream.refreshAccountsList()
          const selected = latest.find((item) => item.source === answer.account) ?? latest[0]
          if (!selected) throw new Error("Run `claude` to sign in first.")
          upstream.setActiveAccountSource(selected.source)
          upstream.saveAccountSource(selected.source)
          const creds = await upstream.getCachedCredentials()
          if (!creds) throw new Error("Run `claude` to refresh your credentials.")
          enabled = true
          await ctx.provider.reload()
          return {
            mode: "auto",
            url: "",
            instructions: `Using ${selected.label} from Claude Code.`,
            callback: Promise.resolve(credential(creds)),
          }
        },
        async refresh() {
          const creds = await upstream.getCachedCredentials()
          if (!creds) throw new Error("Run `claude` to refresh your credentials.")
          return credential(creds)
        },
      })
    })

    // API-key-only installations retain their ordinary provider configuration.
    // The HTTP hooks obtain the real token for each request; no token is in config.
    let enabled = Boolean(account)
    await ctx.provider.transform((editor) => {
      if (!enabled) return
      editor.update("anthropic", (provider) => {
        provider.activation = "enabled"
        provider.settings = {
          ...provider.settings,
          baseURL: "https://api.anthropic.com/v1",
          apiKey: "claude-code-managed",
        }
      })
    })
    await ctx.model.transform((editor) => {
      if (!enabled) return
      for (const model of editor.list("anthropic")) {
        editor.update(model.providerID, model.id, (draft) => {
          draft.cost = [{ input: 0, output: 0, cache: { read: 0, write: 0 } }]
        })
      }
    })
    for (const kind of ["context", "compaction", "generate", "title"]) {
      await ctx.session.hook(kind, (event) => {
        if (!event.system.some((part) => part.type === "text" && part.text.includes(upstream.SYSTEM_IDENTITY))) {
          event.system.unshift({ type: "text", text: upstream.SYSTEM_IDENTITY })
        }
      }, { providerID: "anthropic" })
    }
    const transport = createTransport(upstream)
    await ctx.session.hook("http.request", async (event) => {
      if (enabled) await transport.request(event)
    }, { providerID: "anthropic" })
    await ctx.session.hook("http.response", transport.response, { providerID: "anthropic" })

    let refreshing = false
    const timer = setInterval(async () => {
      if (refreshing) return
      refreshing = true
      try {
        upstream.refreshAccountsList()
        const available = Boolean(upstream.getActiveAccount())
        if (available !== enabled) {
          enabled = available
          await ctx.provider.reload()
        }
        if (enabled) await upstream.refreshIfNeeded(undefined, 60 * 60 * 1000)
      } catch {
        console.warn("Claude Code credential refresh failed; run `claude` to check your sign-in.")
      } finally {
        refreshing = false
      }
    }, 5 * 60 * 1000)
    timer.unref()
    return () => {
      clearInterval(timer)
      transport.dispose()
    }
  },
})

import { expect, test } from "bun:test"
import { createTransport } from "../../home/dot-config/opencode/extensions/claude-auth/transport.js"
import { loadUpstream } from "../../home/dot-config/opencode/extensions/claude-auth/upstream.js"

// Protocol helpers are real; credentials and network are isolated from user accounts.
const helpers = await loadUpstream()
const creds = { accessToken: "test-token", refreshToken: "test-refresh", expiresAt: Date.now() + 3600000 }

function event(url = "https://api.anthropic.com/v1/messages", signal) {
  return {
    model: { providerID: "anthropic", id: "claude-sonnet-4-6" },
    request: new Request(url, {
      method: "POST",
      headers: { "content-type": "application/json", "x-api-key": "placeholder" },
      body: JSON.stringify({
        model: "claude-sonnet-4-6",
        max_tokens: 16,
        messages: [{ role: "user", content: "Read the file." }],
        tools: [{ name: "read", description: "Read", input_schema: { type: "object" } }],
      }),
      signal,
    }),
  }
}

function transport(overrides = {}, fetchImpl = () => { throw new Error("Unexpected network request") }) {
  return createTransport({
    ...helpers,
    getCachedCredentials: async () => creds,
    getCredentialsWithBackoff: async () => null,
    reloadCredentialsFromSource: () => null,
    forceRefreshActiveAccount: async () => null,
    ...overrides,
  }, fetchImpl)
}

test("native HTTP round trip preserves tool names and uses OAuth without an API key", async () => {
  const hooks = transport()
  const input = event()
  await hooks.request(input)
  expect(input.request.headers.get("authorization")).toBe("Bearer test-token")
  expect(input.request.headers.has("x-api-key")).toBe(false)
  expect(new URL(input.request.url).searchParams.get("beta")).toBe("true")
  expect((await input.request.clone().json()).tools[0].name).toBe("mcp_Read")
  const output = {
    request: input.request,
    response: new Response(JSON.stringify({ content: [{ type: "tool_use", name: "mcp_Read" }] }), {
      headers: { "content-type": "application/json" },
    }),
  }
  await hooks.response(output)
  expect((await output.response.json()).content[0].name).toBe("read")
  hooks.dispose()
})

test("401 retries with a rotated token without transforming tool names twice", async () => {
  const calls = []
  const hooks = transport({
    reloadCredentialsFromSource: () => ({ ...creds, accessToken: "rotated" }),
  }, async (url, init) => {
    calls.push(init)
    return new Response('{"content":[]}', { headers: { "content-type": "application/json" } })
  })
  const input = event()
  await hooks.request(input)
  const output = { request: input.request, response: new Response("expired", { status: 401 }) }
  await hooks.response(output)
  expect(output.response.status).toBe(200)
  expect(calls).toHaveLength(1)
  expect(calls[0].headers.get("authorization")).toBe("Bearer rotated")
  expect(JSON.parse(calls[0].body).tools[0].name).toBe("mcp_Read")
  hooks.dispose()
})

test("unrecoverable 401 preserves the original error response", async () => {
  const hooks = transport()
  const input = event()
  await hooks.request(input)
  const output = { request: input.request, response: new Response("expired", { status: 401 }) }
  await hooks.response(output)
  expect(output.response.status).toBe(401)
  expect(await output.response.text()).toBe("expired")
  hooks.dispose()
})

test("credentials never go to a proxy or unrelated endpoint", async () => {
  const hooks = transport({ getCachedCredentials: async () => { throw new Error("Credential access") } })
  for (const url of ["https://proxy.example/v1/messages", "https://api.anthropic.com/other"]) {
    const input = event(url)
    const original = input.request
    await hooks.request(input)
    expect(input.request).toBe(original)
  }
  hooks.dispose()
})

test("long quota waits surface immediately without hidden retries", async () => {
  const hooks = transport()
  const input = event()
  await hooks.request(input)
  const output = {
    request: input.request,
    response: new Response("quota exceeded", { status: 429, headers: { "retry-after": "3600" } }),
  }
  await hooks.response(output)
  expect(output.response.status).toBe(429)
  hooks.dispose()
})

test("abort and unload discard pending response handling", async () => {
  for (const abort of [true, false]) {
    const controller = new AbortController()
    const hooks = transport()
    const input = event(undefined, controller.signal)
    await hooks.request(input)
    if (abort) controller.abort()
    else hooks.dispose()
    const raw = new Response("unprocessed")
    const output = { request: input.request, response: raw }
    await hooks.response(output)
    expect(output.response).toBe(raw)
    hooks.dispose()
  }
})

test("streamed tool names survive chunk boundaries", async () => {
  const hooks = transport()
  const input = event()
  await hooks.request(input)
  const encoder = new TextEncoder()
  const stream = new ReadableStream({
    start(controller) {
      controller.enqueue(encoder.encode('event: content_block_start\ndata: {"type":"content_block_start","content_block":{"type":"tool_use","name":"mcp_'))
      controller.enqueue(encoder.encode('Read","id":"tool-1","input":{}}}\n\n'))
      controller.close()
    },
  })
  const output = {
    request: input.request,
    response: new Response(stream, { headers: { "content-type": "text/event-stream" } }),
  }
  await hooks.response(output)
  const text = await output.response.text()
  expect(text).toContain('"name": "read"')
  expect(text).not.toContain("mcp_")
  hooks.dispose()
})

test("repeated rejected rotated tokens have a hard retry bound", async () => {
  let reads = 0
  let calls = 0
  const hooks = transport({
    reloadCredentialsFromSource: () => ({ ...creds, accessToken: `rotated-${++reads}` }),
  }, async () => {
    calls++
    return new Response("still rejected", { status: 401 })
  })
  const input = event()
  await hooks.request(input)
  const output = { request: input.request, response: new Response("expired", { status: 401 }) }
  await hooks.response(output)
  expect(calls).toBe(2)
  expect(output.response.status).toBe(401)
  hooks.dispose()
})

import { homedir } from "node:os"
import { join } from "node:path"
import { pathToFileURL } from "node:url"

// Resolve from the deployed config, including when mise symlinks this source.
// Internal helper imports are deliberately tied to the exact 2.2.1 dependency.
export async function loadUpstream() {
  const config = process.env.XDG_CONFIG_HOME ?? join(homedir(), ".config")
  const entry = pathToFileURL(join(config, "opencode/node_modules/opencode-claude-auth/dist/index.js"))
  const modules = await Promise.all(
    ["index.js", "credentials.js", "keychain.js", "logger.js"].map(
      (name) => import(new URL(name, entry).href),
    ),
  )
  return Object.assign({}, ...modules)
}

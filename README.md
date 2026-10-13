# dotfiles

My collection of dotfiles, scripts and configurations. Keep in mind that these files are tailored to my personal preferences and setup and your mileage may vary.

Files are deployed with [mise dotfiles](https://mise.jdx.dev/dotfiles.html). The repository is
linked file by file into `~` (`dot-config` becomes `.config`), `*.tera` files are rendered as templates,
and extra links are declared in [`mise.toml`](mise.toml). After every apply,
[`mise/onchange`](mise/onchange) runs reload commands (restart services, rebuild caches) for files whose
contents changed since the last run.

## Installation

```bash
paru -Sy mise
git clone git@github.com:pyrsson/dotfiles.git ~/Projects/personal/dotfiles

mkdir -p ~/.config/mise/conf.d
ln -s ~/Projects/personal/dotfiles ~/.config/mise/conf.d/dotfiles

# per-machine settings (not tracked)
echo 'env = ["sidearm"]' > ~/.config/mise/miserc.local.toml   # or "thinkpad-x1"

mise dot apply --dry-run
mise dot apply --force   # --force replaces existing real files with links
```

## Usage

- `mise dot status` / `mise dot diff` - show what differs
- `mise dot apply` - apply changes (needed after adding files or editing `*.tera` templates)
- `mise/onchange --force` - run every reload command regardless of changes
- `swap-theme` - toggle `vars.theme` between dark and light in the repo's untracked `mise.local.toml` and re-apply
- Host-specific config lives in `mise.<env>.toml` (selected by `miserc.local.toml`): per-host `[vars]`
  used by templates, and links to whole per-host files under `hosts/<env>/` (monitors, niri outputs)

## OpenCode V2

Server settings live in `dot-config/opencode/opencode.json`; terminal preferences live in
`dot-config/opencode/cli.json`. Both are deployed to `~/.config/opencode/`.

The auto-discovered `plugins/claude-auth.js` is a native V2 plugin, tested with OpenCode 2.0.26.
It reuses credential refresh and protocol helpers from the pinned `opencode-claude-auth@2.2.1`
dependency, without loading that package's V1 plugin entrypoint. The legacy plugin dependency
in `package.json` satisfies the helper package's peer dependency; OpenCode supplies the V2 API.

After deploying on a new machine, install the helpers:

```bash
bun install --cwd ~/.config/opencode
```

Sign in using `claude`. The plugin reads Claude Code's credential file (or macOS Keychain),
refreshes tokens, and adapts Anthropic session requests, including titles and compaction.
For multiple accounts, use `/connect` → Anthropic → **Use Claude Code credentials**.
Restart with `opencode service restart` after changing plugin dependencies, since a config
reload may retain imported modules. API-key-only setups retain their ordinary authentication.

Run isolated credential/transport tests from this repository with:

```bash
bun test tests/opencode/claude-auth.test.js
```

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

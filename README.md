# dotfiles

My collection of dotfiles, scripts and configurations. Keep in mind that these files are tailored to my personal preferences and setup and your mileage may vary.

Files are deployed with [mise dotfiles](https://mise.jdx.dev/dotfiles.html). Everything under `home/` is
linked file by file into `~` (`dot-config` becomes `.config`), `*.tera` files are rendered as templates,
and extra links and reload hooks are declared in [`mise/dotfiles.toml`](mise/dotfiles.toml).

## Installation

```bash
paru -Sy mise
git clone git@github.com:pyrsson/dotfiles.git ~/Projects/personal/dotfiles

mkdir -p ~/.config/mise/conf.d
ln -s ~/Projects/personal/dotfiles/mise/dotfiles.toml ~/.config/mise/conf.d/dotfiles.toml

# per-machine settings (not tracked)
echo 'env = ["sidearm"]' > ~/.config/mise/miserc.local.toml   # or "thinkpad-x1"

mise dot apply --dry-run
mise dot apply --force   # --force replaces existing real files with links
```

## Usage

- `mise dot status` / `mise dot diff` - show what differs
- `mise dot apply` - apply changes (needed after adding files or editing `*.tera` templates)
- `swap-theme` - toggle `vars.theme` between dark and light in `~/.config/mise/config.local.toml` and re-apply
- Host-specific template blocks use `{% if "sidearm" in mise_env | default(value=[]) %}`

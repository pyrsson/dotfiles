#!/bin/bash

set -euo pipefail

ln -sfT "$HOME/.local/share/nvim/lazy/tokyonight.nvim/extras/eza/tokyonight_storm.yml" "$HOME/.local/share/eza/theme.yml"
ln -sfT "$HOME/.local/share/nvim/lazy/tokyonight.nvim/extras/fish_themes" "$HOME/.config/fish/themes"
ln -sfT "$HOME/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime" "$HOME/.config/bat/themes"

bat cache --build

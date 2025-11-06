command -q fzf; or return 0

fzf --fish | source

# makes fzf history preview open in tmux popup
set -gx FZF_DEFAULT_OPTS "--layout=reverse --tmux 80%,50% --color=bg+:#2d3f76 \
  --color=bg:-1 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:-1 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
  "

set -gx FZF_CTRL_R_OPTS "--layout=reverse --preview 'echo {}' --preview-window down:3:wrap:hidden:border-horizontal --bind '?:toggle-preview'"
set -gx FZF_CTRL_T_OPTS "--preview 'test -d {} && eza -la --color=always {} || bat --style=numbers --color=always --line-range=:500 {} 2> /dev/null | head -200'"

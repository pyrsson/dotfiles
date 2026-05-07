command -q fzf; or return 0

fzf --fish | source

function __sync_fzf_colors --on-variable fish_terminal_color_theme
    # tokyonight night
    if test "$fish_terminal_color_theme" = dark
        set -gx FZF_DEFAULT_OPTS "--layout=reverse --tmux 80%,50% \
--highlight-line \
--info=inline-right \
--ansi \
--layout=reverse \
--color=bg+:#283457 \
--color=bg:#16161e \
--color=border:#27a1b9 \
--color=fg:#c0caf5 \
--color=gutter:#16161e \
--color=header:#ff9e64 \
--color=hl+:#2ac3de \
--color=hl:#2ac3de \
--color=info:#545c7e \
--color=marker:#ff007c \
--color=pointer:#ff007c \
--color=prompt:#2ac3de \
--color=query:#c0caf5:regular \
--color=scrollbar:#27a1b9 \
--color=separator:#ff9e64 \
--color=spinner:#ff007c \
"
    else if test "$fish_terminal_color_theme" = light
        # tokyonight day
        set -gx FZF_DEFAULT_OPTS "--layout=reverse --tmux 80%,50% \
--highlight-line \
--info=inline-right \
--ansi \
--layout=reverse \
--highlight-line \
--info=inline-right \
--layout=reverse \
--color=bg+:#b7c1e3 \
--color=bg:#d0d5e3 \
--color=border:#4094a3 \
--color=fg:#3760bf \
--color=gutter:#d0d5e3 \
--color=header:#b15c00 \
--color=hl+:#188092 \
--color=hl:#188092 \
--color=info:#8990b3 \
--color=marker:#d20065 \
--color=pointer:#d20065 \
--color=prompt:#188092 \
--color=query:#3760bf:regular \
--color=scrollbar:#4094a3 \
--color=separator:#b15c00 \
--color=spinner:#d20065 \
"
    end
end

set -gx FZF_CTRL_R_OPTS "--layout=reverse --preview 'echo {}' --preview-window down:3:wrap:hidden:border-horizontal --bind '?:toggle-preview'"
set -gx FZF_CTRL_T_OPTS "--preview 'test -d {} && eza -la --color=always {} || bat --style=numbers --color=always --line-range=:500 {} 2> /dev/null | head -200'"

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx CDPATH . ~ ~/work ~/github ~/vasttrafik
    direnv hook fish | source
    fzf --fish | source
    # makes fzf history preview open in tmux popup
    set -gx FZF_DEFAULT_OPTS "--reverse --tmux 80%,50% --color dark,prompt:blue,hl+:cyan,hl:cyan,bg+:gray,gutter:-1,fg+:blue:bold,pointer:cyan,info:blue,border:gray"
    set -gx FZF_CTRL_R_OPTS "--reverse --preview 'echo {}' --preview-window down:3:wrap:hidden:border-horizontal --bind '?:toggle-preview'"
    alias k=kubectl
    alias kx=kubectx
    alias kn=kubens
    alias vim=nvim
end

set -gx EDITOR nvim

set -gx N_PREFIX "$HOME/.n"
if test -e $N_PREFIX
    fish_add_path "$N_PREFIX/bin"
end

fish_add_path "$HOME/.krew/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/go/bin"

set theme tokyonight_moon

set hydro_color_pwd $fish_color_command
set hydro_color_git $fish_color_param

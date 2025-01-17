if status is-interactive
    # set date (date +"%s")
    # set last_update (stat -c %Y ~/github/dotfiles/.git/FETCH_HEAD)
    # if $date - $last_update -gt 432000
    #     update-dotfiles
    # end
    # Commands to run in interactive sessions can go here
    set -gx CDPATH . ~ ~/work ~/github ~/vasttrafik
    type -q direnv && direnv hook fish | source
    type -q fzf && fzf --fish | source
    # makes fzf history preview open in tmux popup
    set -gx FZF_DEFAULT_OPTS "--reverse --tmux 80%,50% --color dark,prompt:blue,hl+:cyan,hl:cyan,bg+:gray,gutter:-1,fg+:blue:bold,pointer:cyan,info:blue,border:gray"
    set -gx FZF_CTRL_R_OPTS "--reverse --preview 'echo {}' --preview-window down:3:wrap:hidden:border-horizontal --bind '?:toggle-preview'"
    set -gx FZF_CTRL_T_OPTS "--preview 'test -d {} && eza -la --color=always {} || bat --style=numbers --color=always --line-range=:500 {} 2> /dev/null | head -200'"

    # completion
    type -q kustomize && kustomize completion fish | source
    type -q talosctl && talosctl completion fish | source
    type -q stern && stern --completion fish | source
    type -q cue && cue completion fish | source
    type -q kcl && kcl completion fish | source
    type -q hcp && hcp completion fish | source

    # alias
    type -q eza && alias ls=eza
    type -q bat && alias cat=bat
    alias k=kubectl
    alias kx=kubectx
    alias kn=kubens
    alias vim=nvim
    alias pm=podman
end

set fish_greeting

set -gx EDITOR nvim
set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"

set -gx N_PREFIX "$HOME/.n"
fish_add_path "$N_PREFIX/bin"

fish_add_path "$HOME/.krew/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.deno/bin"
fish_add_path "$HOME/.cargo/bin"

set theme tokyonight_moon

set hydro_color_pwd $fish_color_command
set hydro_color_git $fish_color_param

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx CDPATH . ~ ~/work ~/github ~/projects
    abbr vim nvim
end

set fish_greeting

set -gx EDITOR nvim
set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"
set -gx LESS "--mouse --wheel-lines=3"

fish_add_path "$HOME/.local/bin"; or true
fish_add_path "$HOME/.krew/bin"; or true
fish_add_path "$HOME/go/bin"; or true
fish_add_path "$HOME/.cargo/bin"; or true

set hydro_color_pwd $fish_color_command
set hydro_color_git $fish_color_param

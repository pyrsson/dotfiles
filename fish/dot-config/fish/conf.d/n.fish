command -q n; or return 0

set -gx N_PREFIX "$HOME/.n"
fish_add_path -m "$N_PREFIX/bin"

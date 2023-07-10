export FPATH="${HOME}/github/dotfiles/functions:${FPATH}"
for f in "${HOME}"/github/dotfiles/functions/*; do
  autoload -Uz $f
done

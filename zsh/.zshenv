for f in "${HOME}"/.oh-my-zsh/functions/*; do
  autoload -Uz $f
done

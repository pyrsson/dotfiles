# pyrsson.zsh-theme

autoload -U colors
colors


typeset +H return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %(?.%F{cyan}.%F{red})%(!.#.>)%f '
RPS1='${return_code}'

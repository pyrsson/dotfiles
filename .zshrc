# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="${HOME}/github/dotfiles/ohmyzsh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ -e ~/.ssh/id_rsa ]]; then
  plugins=(git ssh-agent)
  zstyle :omz:plugins:ssh-agent identities id_rsa
else
  plugins=(git)
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export FPATH="${HOME}/github/dotfiles/functions:${FPATH}"
autoload -Uz update-dotfiles

# auto pull git dotfiles
if [[ $(( $(date +"%s") - $(stat -c %Y ~/github/dotfiles/.git/FETCH_HEAD) )) -gt $(( 3600 * 20 )) ]]; then
  update-dotfiles
fi

# env
export EDITOR=vim
export CDPATH=.:~:~/work:~/github
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="${HOME}/.local/bin:$PATH"
export PATH="/opt/istio-1.11.3/bin:$PATH"
if type direnv &> /dev/null; then eval "$(direnv hook zsh)"; fi


# aliases
alias gst="git status -sb"
alias reload="source ${HOME}/.zshrc"
if type docker-compose &> /dev/null; then alias dc="docker-compose"; fi
if type kubectl &> /dev/null; then alias kc="kubectl"; fi
if type kubectx &> /dev/null; then alias kx="kubectx"; fi
if type kubens &> /dev/null; then alias kn="kubens"; fi
if type podman &> /dev/null; then alias pm="podman"; fi

# behavior
autoload -Uz backward-kill-word-match

bindkey '^W' backward-kill-space-word
zle -N backward-kill-space-word backward-kill-word-match
zstyle :zle:backward-kill-space-word word-style space

bindkey '^[^H' backward-kill-bash-word
zle -N backward-kill-bash-word backward-kill-word-match
zstyle :zle:backward-kill-bash-word word-style bash

# completion
autoload -U +X bashcompinit && bashcompinit
if [[ -e /usr/local/bin/mc ]]; then complete -o nospace -C /usr/local/bin/mc mc; fi
if [[ -e /usr/local/bin/terraform ]]; then
  complete -o nospace -C /usr/local/bin/terraform terraform
fi
if [[ -e /etc/bash_completion.d/azure-cli ]]; then
  source /etc/bash_completion.d/azure-cli
fi

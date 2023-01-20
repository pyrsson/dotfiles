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
  plugins=(git ssh-agent fzf golang)
  zstyle :omz:plugins:ssh-agent identities id_rsa
else
  plugins=(git fzf golang)
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export FPATH="${HOME}/github/dotfiles/functions:${FPATH}"
for f in "${HOME}"/github/dotfiles/functions/*; do
  autoload -Uz $f
done

# auto pull git dotfiles
if [[ $(( $(date +"%s") - $(stat -c %Y ~/github/dotfiles/.git/FETCH_HEAD) )) -gt $(( 3600 * 24 * 5 )) ]]; then
  update-dotfiles
fi

# env
export EDITOR=nvim
export CDPATH=.:~:~/work:~/github:~/vasttrafik
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
export PATH="$PATH:${HOME}/.local/bin"
export PATH="$PATH:/opt/istio-1.12.0/bin"
export PATH="$PATH:${HOME}/.linkerd2/bin"
export PATH="$PATH:${HOME}/go/bin"
if type direnv &> /dev/null; then eval "$(direnv hook zsh)"; fi
export GPG_TTY=$(tty)
source "$HOME/.cargo/env"

if [[ -e ~/.dotnet ]]; then
  export PATH="${HOME}/.dotnet/tools:$PATH"
  export DOTNET_ROOT="${HOME}/.dotnet"
fi

if [[ -e ~/.deno ]]; then
  export DENO_INSTALL="/home/simon/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# aliases
alias gst="git status -sb"
alias reload="source ${HOME}/.zshrc"
alias sduo="command sudo "
alias pls="command sudo "
alias sudo="command sudo "
alias start-k3s="tmux new -s k3s -d \"sudo ${HOME}/github/dotfiles/start-k3s\""
alias docker="sudo podman"
alias ta="tmux -l new-session -A -s main"
alias stctl="systemctl"
alias e="$EDITOR"

if type docker-compose &> /dev/null; then alias dc="docker-compose"; fi
if type kubectl &> /dev/null; then alias k="kubectl"; fi
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
autoload -U +X compinit && compinit
if [[ -e /usr/local/bin/mc ]]; then complete -o nospace -C /usr/local/bin/mc mc; fi
if [[ -e /usr/local/bin/terraform ]]; then
  complete -o nospace -C /usr/local/bin/terraform terraform
fi
if [[ -e /etc/bash_completion.d/azure-cli ]]; then
  source /etc/bash_completion.d/azure-cli
fi


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# Path to your oh-my-zsh installation.
# TODO: Move this to the custom location under host-setup source. Maybe as a git submodule?
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vagrant docker docker-compose)

# User configuration

source $ZSH/oh-my-zsh.sh

# Get OS and architecture to do OS specific actions.
OS="$(uname)"
ARC="$(uname -m)"

# Visual customizations.
zle_highlight=(default:bold)
## Set ls colors on Linux.
if [ $OS = "Linux" ]
then
  alias ls='ls --color=auto'
fi

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if hash rbenv 2>/dev/null
then
  eval "$(rbenv init -)"
fi

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Go
# These are universal.
export GOPATH="$HOME/Projects/go"
export PATH="$PATH:$GOPATH/bin"
# This is only needed on Linux or pkg installation on macOS. macOS with brew is already in path.
export PATH="$PATH:/usr/local/go/bin"

# Composer
export PATH="$PATH:$HOME/.composer/vendor/bin"

# Brew paths for macOS.
if [ $OS = "Darwin" ]
then
  # export PATH="$PATH:/usr/local/sbin"
fi

# Ansible Vault
export WT_ANSIBLE_VAULT_FILE="$HOME/.WT_ANSIBLE_VAULT_FILE"
export ANSIBLE_VAULT_PASSWORD_FILE="$HOME/.op.sh"

# Kontena CLI
# export SSL_IGNORE_ERRORS=true

# TODO: Maybe change this so that the default username can be given as argument to the host-setup.sh that will put it here?

export DEFAULT_USER="$USER"

# Include local secrets.
if [ -f $HOME/.secrets-zshrc.sh ]
then
  source $HOME/.secrets-zshrc.sh
fi

# Enable screen when using SSH
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
then
  if [ -z "$STY" ]
    then screen -R
  fi
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

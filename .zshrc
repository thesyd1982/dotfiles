# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded.
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="minimal"

# Set list of themes to pick from when loading at random
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment to disable automatic updates.
# zstyle ':omz:update' mode disabled

# Uncomment to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Enable command auto-correction.
# ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# History settings
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.cache/zsh/history"
HIST_STAMPS="mm/dd/yyyy"

# Custom folder for oh-my-zsh
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Source oh-my-zsh
source "$ZSH/oh-my-zsh.sh"

# User configuration
export MANPATH="/usr/local/man:$MANPATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"

# Set language environment
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

# Preferred editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
  export VISUAL="nvim"
  export SUDO_EDITOR="nvim"
else
  export EDITOR='nvim'
fi

# Aliases
alias v=nvim
alias vzc="v ~/.zshrc"
alias vomz="v ~/.oh-my-zsh"
alias vnv='v ~/.config/nvim'

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Edit line in vim buffer (Ctrl+V)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
bindkey -M menuselect 'down' vi-down-line-or-history

# Re-source this file with Alt+R
bindkey -s '^[r' "source ~/.zshrc\n"

# Clear screen with Alt+G
bindkey -s '^[g' "clear\n"

# Add Ansible path
export PATH="$PATH:$HOME/.local/bin"

# Go path
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
#
export PATH="$PATH:$HOME/scripts/"
# Init zoxide
eval "$(zoxide init zsh)"

# Aliases
alias "cd"="z"
alias "cat"="batcat"
alias air='~/go/bin/air'
alias kcef='tmux new-session -A -s kce-front'
alias githubssh="ssh -T git@github.com"
# Start SSH service
sudo service ssh start


# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"# pnpm
# end

alias viteconf=viteconf.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Start cron service
sudo service cron start > /dev/null 2>&1
export FUNCNEST=100

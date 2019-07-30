# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
autoload -U zmv

# Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
if [[ -n "$MSYSTEM" ]]; then
    # hard-coded path for MSYS/MinGW since symlinks don't work there
    __linuxfiles_dir="$HOME/linuxfiles"
else
    __linuxfiles_dir="$(dirname "$(readlink -e ~/.zshrc)")"
fi
ZSH_CUSTOM=$__linuxfiles_dir/zsh_custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

#export PATH="${HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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

# clear the theme, allow it to be set by myshrc*
# and use the default if it doesn't
unset ZSH_THEME

[[ -e ~/myshrc ]] && . ~/myshrc
[[ -e ~/myshrc_local ]] && . ~/myshrc_local

if [[ -z $ZSH_THEME ]]; then
    if [[ -d $WORKSPACES_ROOT ]]; then
        ZSH_THEME=zwild-workspace
    else
        ZSH_THEME=zwild
    fi
fi

source $ZSH/oh-my-zsh.sh

#unsetopt AUTO_CD
unsetopt share_history
unsetopt cdable_vars
setopt shwordsplit
#setopt nullglob
unsetopt nullglob
unsetopt nomatch
unsetopt pushd_ignore_dups
setopt bsd_echo

alias srcrc="source ~/.zshrc"
alias mmv="noglob zmv -W"
alias dh="dirs -v"

# syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[arg0]='none'
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[path]='none'

source $__linuxfiles_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
unset __linuxfiles_dir

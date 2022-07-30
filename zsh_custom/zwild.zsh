#! /bin/zsh
# Allen Wild zwild.zsh
# Functions that specifically involve oh-my-zsh
# Everything generic should be in myshrc

# re-run all of my aliases from myshrc because oh my zsh clobbers some (like ls)
eval "$(grep -Eh '^(un)?alias' ~/myshrc)"
[[ -f ~/myshrc_local ]] && eval "$(grep -Eh '^(un)?alias' ~/myshrc_local)"

# default this option to false for compatibility with normal themes
# a theme may set this to true to add parse_git_dirty() before the branch is displayed,
# allowing for the branch text to be colored depending on status
ZSH_THEME_GIT_PROMPT_DIRTY_BEFORE_BRANCH="false"

function zsh_nogit() {
    ZSH_GIT_PROMPT=0
}

function git_prompt_info() {
    ( [[ "$ZSH_GIT_PROMPT" != "0" && "$PWD" != "$HOME" ]] && git rev-parse --git-dir &>/dev/null ) || return 0
    if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
        ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
            ref=tags/$(command git describe --tags --exact-match HEAD 2>/dev/null) || \
            ref=$(command git show-ref 2>/dev/null | sed -n '/^'$(command git rev-parse HEAD 2>/dev/null)' refs\/remotes\/\(m\/.*\)/,${s//\1/p;q0};$q1') || \
            ref=$(command git rev-parse --short HEAD 2> /dev/null)
        [[ -n "$ref" ]] || return 0

        # re-order the git prompt so that dirty/clean can be before the current branch
        if [[ $ZSH_THEME_GIT_PROMPT_DIRTY_BEFORE_BRANCH == "true" ]]; then
            echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
        else
            echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
        fi
    fi
}

function zwild_get_view() {
    if [[ -n $TOP ]]; then
        if [[ $PWD == $TOP ]]; then
            return 0
        elif [[ $PWD == $TOP/* ]]; then
            echo -n "$(basename "$TOP")::"
            return 0
        else
            local __zwild_not_in_top="$(basename "$TOP")!!"
        fi
    fi
    if [[ -n $WORKSPACES_ROOT ]] && [[ $PWD == $WORKSPACES_ROOT/* ]]; then
        echo -n "$__zwild_not_in_top"
        [[ $PWD == $WORKSPACES_ROOT/*/* ]] && echo "${${PWD#${WORKSPACES_ROOT}/}%%/*}::"
    fi
}
ZSH_THEME_TERM_TAB_TITLE_IDLE='$(zwild_get_view)%1d'

# Runs before executing the command
# copied/extended from oh-my-zsh/lib/termsupport.zsh
function omz_termsupport_preexec {
    emulate -L zsh
    setopt extended_glob

    if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
        return
    fi

    # only set tab title in tmux for certain cases
    if [[ -n $TMUX ]]; then
        case $1 in
            htop|minicom) title $1 ;;
        esac
        return
    else
        # set a sensible title when launching tmux (to avoid a bunch of windows all labeled "tmx")
        case "$1" in
            tmx|tmux)
                title "tmux $HOST"
                return
                ;;
        esac
    fi

    # cmd name only, or if this is sudo or ssh, the next cmd
    local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
    local LINE="${2:gs/%/%%}"

    title '$CMD' '%100>...>$LINE%<<'
}

# Set terminal window and tab/icon title
# Copied from oh-my-zsh/lib/termsupport.zsh, changed "nopromptsubst" option to
# just "promptsubst" so that zwild_get_view in tmux tab titles works again.
# It was "broken" in omz commit a263cda as a fix for potential command injection,
# but command injection is precisely what I want for my tmux tab titles showing
# the view nicely.
function title {
  setopt localoptions promptsubst

  # Don't set the title if inside emacs, unless using vterm
  [[ -n "${INSIDE_EMACS:-}" && "$INSIDE_EMACS" != vterm ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;${2:q}\a" # set window name
        print -Pn "\e]1;${1:q}\a" # set tab name
      else
        # Try to use terminfo to set the title if the feature is available
        if (( ${+terminfo[fsl]} && ${+terminfo[tsl]} )); then
          print -Pn "${terminfo[tsl]}$1${terminfo[fsl]}"
        fi
      fi
      ;;
  esac
}

# if this looks like a serial console, disable preexec and idle functions
# that write escape codes which can show up as junk on the console
if [[ $TTY == /dev/ttyS* || $TTY == /dev/ttyAMA* ]]; then
    DISABLE_AUTO_TITLE=true
fi

# automatically update DISPLAY in tmux sessions
if [[ -n "$TMUX" ]]; then
    function zwild_display_precmd {
        local _display="$(tmux showenv DISPLAY 2>/dev/null)"
        case "$_display" in
            DISPLAY=*) export DISPLAY="${_display#DISPLAY=}" ;;
            -DISPLAY) unset DISPLAY ;;
        esac
    }
    autoload -U add-zsh-hook
    add-zsh-hook precmd zwild_display_precmd
fi

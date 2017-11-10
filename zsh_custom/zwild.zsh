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

function git_prompt_info() {
    ( [[ "$PWD" != "$HOME" ]] && git rev-parse --git-dir &>/dev/null ) || return 0
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
            echo -n "$(basename $TOP)::"
            return 0
        else
            local __zwild_not_in_top="$(basename $TOP)!!"
        fi
    fi
    if [[ -n $WORKSPACES_ROOT ]] && [[ $PWD == $WORKSPACES_ROOT/* ]]; then
        echo -n "$__zwild_not_in_top"
        [[ $PWD == $WORKSPACES_ROOT/*/* ]] && echo "${${PWD#${WORKSPACES_ROOT}/}%%/*}::"
    fi
}
ZSH_THEME_TERM_TAB_TITLE_IDLE='$(zwild_get_view)%1d'

# don't set terminal title when running a command in tmux
if [[ -n $TMUX ]]; then
    # disable omz defaults in termsupport.zsh
    unset preexec_functions 2>/dev/null

    function zwild_tmux_preexec() {
        case $1 in
            htop|minicom)
                title $1 $1
                ;;
        esac
    }

    preexec_functions=(zwild_tmux_preexec)
fi

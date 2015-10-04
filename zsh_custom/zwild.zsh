#! /bin/zsh

# re-run all of my aliases from myshrc because oh my zsh clobbers some (like ls)
eval "$(grep -Eh '^(un)?alias' ~/myshrc)"
[[ -f ~/myshrc_local ]] && eval "$(grep -Eh '^(un)?alias' ~/myshrc_local)"

# default this option to false for compatibility with normal themes
# a theme may set this to true to add parse_git_dirty() before the branch is displayed,
# allowing for the branch text to be colored depending on status
ZSH_THEME_GIT_PROMPT_DIRTY_BEFORE_BRANCH="false"

function git_prompt_info() {
    if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
        ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0

        # re-order the git prompt so that dirty/clean can be before the current branch
        if [[ $ZSH_THEME_GIT_PROMPT_DIRTY_BEFORE_BRANCH == "true" ]]; then
            echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
        else
            echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
        fi
    fi
}

alias | grep -q gcp && unalias gcp
function gcp {
    git commit -m "$@" && git push
}

alias | grep -q gcap && unalias gcap
function gcap {
    git commit -a -m "$@" && git push
}

alias gdh='git diff HEAD'

if [[ -e /cygdrive/c/Program\ Files\ \(x86\)/Vim/vim74/gvim.exe ]]; then
    export WINDOWS_HOME='C:\Users\'${HOME##*/}
    function gvim()
    {
        for i in "$@"; do
            HOME=$WINDOWS_HOME cygstart '/cygdrive/c/Program Files (x86)/Vim/vim74/gvim.exe' --remote-tab-silent \"$i\"
        done
    }
fi

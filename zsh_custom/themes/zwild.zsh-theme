#!/bin/zsh
local ret_status="%(?:%{$fg_bold[green]%}» :%{$fg_bold[red]%}» %s)"
[[ $USER == root ]] && local rg_color='red' || local rg_color='green'
PROMPT='${ret_status}%{$fg_bold['$rg_color']%}%n@%{$fg_bold[blue]%}%m %{$fg[cyan]%}%c $(git_prompt_info)%{$fg_bold['$rg_color']%}%# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_DIRTY_BEFORE_BRANCH="true"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

#!/bin/zsh
local ret_status="%(?:%{$fg_bold[green]%}» :%{$fg_bold[red]%}» %s)"

function zsh_prompt_print_view
{
    local view="${PWD#${WORKSPACES_ROOT}/}"
    view=${view%%/*}
    [[ -n $view ]] && echo "[%{$fg[yellow]%}${view}%{$fg_bold[blue]%}]"
}
function zsh_prompt_print_pwd
{
    pwd | sed -e "s#^${WORKSPACES_ROOT}/[^/]*/##" \
              -e "s#^${HOME}#~#"
}

PROMPT='
${ret_status}%{$fg_bold[green]%}%n@%{$fg_bold[blue]%}%m$(zsh_prompt_print_view)$(git_prompt_info) %{$fg_bold[cyan]%}$(zsh_prompt_print_pwd)%{$fg_bold[green]%}
%#%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_DIRTY_BEFORE_BRANCH="true"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

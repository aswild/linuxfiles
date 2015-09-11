local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%n@%{$fg_bold[blue]%}%m %{$fg[cyan]%}%c $(git_prompt_info)%{$fg_bold[green]%}%# %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_DIRTY_BEFORE_BRANCH="true"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

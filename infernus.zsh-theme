if [ $UID -eq 0 ]; then
    PRSEP="☠"
else
    PRSEP="∞"
fi

local ret_status="%(?:%{$fg_bold[green]%}$PRSEP :%{$fg_bold[red]%}$PRSEP %s)"

PROMPT='%{$fg[yellow]%}$(git_prompt_info)%{$fg[blue]%} %c $ret_status %{$reset_color%}'
RPROMPT='%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%} →%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}"

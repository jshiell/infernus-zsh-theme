if [[ $UID -eq 0 ]]; then
    PRSEP="☠"
else
    PRSEP="∞"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%} →%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}"

# all credit to https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/git.zsh
infernus_theme_git_prompt_info() {
    local ref
    if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
        ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
        echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(infernus_theme_parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
}

infernus_theme_parse_git_dirty() {
    local STATUS
    local -a FLAGS
    FLAGS=('--porcelain')
    if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
        if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
            FLAGS+='--untracked-files=no'
        fi
        case "$GIT_STATUS_IGNORE_SUBMODULES" in
        git)
            # let git decide (this respects per-repo config in .gitmodules)
            ;;
        *)
            # if unset: ignore dirty submodules
            # other values are passed to --ignore-submodules
            FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
            ;;
        esac
        STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    fi
    if [[ -n $STATUS ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
        echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
}

local ret_status="%(?:%{$fg_bold[green]%}$PRSEP :%{$fg_bold[red]%}$PRSEP %s)"

PROMPT='%{$fg[yellow]%}$(infernus_theme_git_prompt_info)%{$fg[blue]%} %c $ret_status %{$reset_color%}'
RPROMPT='%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}'

INFERNUS_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
INFERNUS_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%} →%{$reset_color%}"
INFERNUS_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
INFERNUS_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}"

infernus_theme_git_prompt_info() {
    local VCS_REF
    VCS_REF="$vcs_info_msg_0_"
    if [[ -n "$VCS_REF" ]]; then
        if [[ "${VCS_REF/.../}" == "$VCS_REF" ]]; then
            VCS_REF="$BRANCH $VCS_REF"
        else
            VCS_REF="$DETACHED ${VCS_REF/.../}"
        fi

        print -n "$INFERNUS_THEME_GIT_PROMPT_PREFIX$VCS_REF$(infernus_theme_parse_git_dirty)$INFERNUS_THEME_GIT_PROMPT_SUFFIX"
    fi
}

infernus_theme_parse_git_dirty() {
    is_dirty() {
        test -n "$(git status --porcelain --ignore-submodules)"
    }

    if is_dirty; then
        print -n "$INFERNUS_THEME_GIT_PROMPT_DIRTY"
    else
        print -n "$INFERNUS_THEME_GIT_PROMPT_CLEAN"
    fi
}

infernus_theme_separator() {
    local PRSEP="∞"
    if [[ $UID -eq 0 ]]; then
        PRSEP="☠"
    fi

    if [[ $RETVAL -ne 0 ]]; then
        print -n "%{$fg_bold[red]%}$PRSEP"
    else
        print -n "%{$fg_bold[green]%}$PRSEP"
    fi
}

infernus_theme_precmd() {
    RETVAL=$?
    vcs_info
    PROMPT='%{$fg[yellow]%}$(infernus_theme_git_prompt_info)%{$fg[blue]%} %c $(infernus_theme_separator) %{$reset_color%}'
    RPROMPT='%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}'
}

infernus_theme_setup() {
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    prompt_opts=(cr subst percent)

    add-zsh-hook precmd infernus_theme_precmd

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' check-for-changes false
    zstyle ':vcs_info:git*' formats '%b'
    zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

infernus_theme_setup "$@"

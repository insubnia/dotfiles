#!/bin/zsh

source $HOME/workspace/dotfiles/common

if [[ "$OSTYPE" == "darwin"* ]]; then
    # type "p10k configure" to reconfigure
    ZSH_THEME="powerlevel10k/powerlevel10k"

    # Customize by editing ~/.p10k.zsh
    # In order to show user@hostname, remove below line
    # typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
elif [[ "$OSTYPE" == "linux"* ]]; then
    ZSH_THEME="powerlevel9k/powerlevel9k"

    # POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs background_jobs)
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon user dir vcs background_jobs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator battery time date)
    POWERLEVEL9K_TIME_FORMAT=%t
    POWERLEVEL9K_DATE_FORMAT=%D{%F(%a)}
    POWERLEVEL9K_MODE='nerdfont-complete'

    if [[ -n 'grep "Microsoft" /proc/version' ]]; then
        # remove vcs for speed-up 
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]/(vcs)})
    else
        # echo "Native Linux"
    fi
else
    echo $OSTYPE
fi

plugins+=(
    colored-man-pages
    autojump
    extract
)

# custom
plugins+=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    alias-tips
    k
)

source $ZSH/oh-my-zsh.sh
unsetopt BG_NICE

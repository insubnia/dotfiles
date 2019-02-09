#!/bin/zsh

source $HOME/workspace/dotfiles/common

ZSH_DISABLE_COMPFIX="true"

if [[ "$OSTYPE" == "darwin"* ]]; then
    ZSH_THEME="powerlevel9k/powerlevel9k"

    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs background_jobs)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator time date)
    POWERLEVEL9K_TIME_FORMAT=%t
    POWERLEVEL9K_DATE_FORMAT=%D{%F(%a)}

    POWERLEVEL9K_MODE='nerdfont-complete'
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs background_jobs)
fi

plugins+=(
    git
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

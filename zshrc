#!/bin/zsh

source $HOME/workspace/dotfiles/common

ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_DISABLE_COMPFIX="true"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs background_jobs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator time date)
POWERLEVEL9K_TIME_FORMAT=%t
POWERLEVEL9K_DATE_FORMAT=%D{%F(%a)}

# settings with nerd font
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs background_jobs)

plugins=(
    git
    colored-man-pages
    autojump
    extract
    z

    # custom
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
unsetopt BG_NICE

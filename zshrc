#!/bin/zsh

# zstyle
## case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh

zplug "djui/alias-tips"
zplug "supercrabtree/k"

if [[ "$OSTYPE" == "darwin"* ]]; then
    zplug "romkatv/powerlevel10k", as:theme, depth:1
    # type "p10k configure" to reconfigure
    # Customize by editing ~/.p10k.zsh
    # In order to show user@hostname, remove below line
    # typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
elif [[ "$OSTYPE" == "linux"* ]]; then
    if grep -q -Irin microsoft /proc/version; then
        # WSL (Windows Subsystem for Linux)
        zplug "themes/candy", from:oh-my-zsh, as:theme
    else
        # Native Linux System
        zplug "bhilburn/powerlevel9k", use:"powerlevel9k.zsh-theme"

        # POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs background_jobs)
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon user dir vcs background_jobs)
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator battery time date)
        POWERLEVEL9K_TIME_FORMAT=%t
        POWERLEVEL9K_DATE_FORMAT=%D{%F(%a)}
        POWERLEVEL9K_MODE='nerdfont-complete'
        # POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]/(vcs)})  # remove vcs for speed-up
    fi
else
    echo $OSTYPE
    zplug "themes/agnoster", from:oh-my-zsh
fi

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load

source $HOME/workspace/dotfiles/common

unsetopt BG_NICE

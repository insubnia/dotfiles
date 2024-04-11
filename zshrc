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

# Choose theme depending on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    zplug "romkatv/powerlevel10k", as:theme, depth:1
elif [[ "$OSTYPE" == "linux"* ]]; then
    if grep -q -Irin microsoft /proc/version; then  # WSL
        zplug 'dracula/zsh', as:theme
        # https://stackoverflow.com/questions/12765344/oh-my-zsh-slow-but-only-for-certain-git-repo
        git config --global oh-my-zsh.hide-status 1
        git config --global oh-my-zsh.hide-dirty 1
    else  # Native
        zplug "romkatv/powerlevel10k", as:theme, depth:1
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
# zplug load --verbose
zplug load

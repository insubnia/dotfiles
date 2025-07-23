#!/bin/zsh

# zstyle
## case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/autojump/autojump.plugin.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/extract/extract.plugin.zsh
zinit light djui/alias-tips
zinit light supercrabtree/k

if [[ "$OSTYPE" == "darwin"* ]]; then
    zinit ice depth=1
    zinit light romkatv/powerlevel10k
elif [[ "$OSTYPE" == "linux"* ]]; then
    if grep -q -Irin microsoft /proc/version; then
        zinit ice pick"zsh" atclone"cp zsh dracula.zsh-theme" atpull"%atclone"
        zinit light dracula/zsh
        # https://stackoverflow.com/questions/12765344/oh-my-zsh-slow-but-only-for-certain-git-repo
        git config --global oh-my-zsh.hide-status 1
        git config --global oh-my-zsh.hide-dirty 1
    else
        zinit ice depth=1
        zinit light romkatv/powerlevel10k
    fi
else
    echo $OSTYPE
    zinit snippet OMZ::themes/agnoster.zsh-theme
fi

# NOTE: insert below lines into ~/.p10k.zsh in order to indicate background job
# typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#   ...
#   background_jobs
#   prompt_char
# )
# typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='🎃'
# typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=grey

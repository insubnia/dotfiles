# sis zshrc
if [ $PWD = $HOME ]; then
    mkdir -p workspace
    cd workspace
fi

# ZSH_THEME="agnoster"
# ZSH_THEME="avit"
ZSH_THEME="powerlevel9k/powerlevel9k"

plugins=(
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

alias vi='vim'
alias python='python3'
alias gdf='git difftool -t vimdiff'
alias ff='find . -type f -iname'

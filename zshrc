# sis zshrc
if [ $PWD = $HOME ]; then
    mkdir -p workspace
    cd workspace
fi

ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs background_jobs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator time date)
POWERLEVEL9K_TIME_FORMAT=%t
POWERLEVEL9K_DATE_FORMAT=%D{%F(%a)}

# nerd font
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

alias vi='vim'
alias python='python3'
alias gdf='git difftool -t vimdiff'
alias ff='find . -type f -iname'

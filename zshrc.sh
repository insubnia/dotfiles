# sis zshrc
plugins=(
    colored-man-pages
    autojump

    # custom
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
unsetopt BG_NICE

export DISPLAY=:0

alias python='python3'
alias grep='grep --color=auto --exclude={tags} --exclude-dir={.git,.svn}'
alias ssh='ssh -X'

git config --global diff.tool vimdiff
git config --global difftool.prompt true

# merge.tool: vimdiff, vimdiff2, vimdiff3
# conflictstyle: merge, diff3
git config --global merge.tool vimdiff2
git config --global mergetool.prompt true
git config --global merge.conflictstyle diff3

git config --global alias.mylog     "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

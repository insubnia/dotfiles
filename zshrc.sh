# sis zshrc
if [ $PWD = $HOME ]; then
    mkdir -p workspace
    cd workspace
fi

ZSH_THEME="agnoster"
plugins=(
    colored-man-pages
    autojump
    extract

    # custom
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
unsetopt BG_NICE

alias python='python3'
alias grep='grep --color=auto --exclude={tags} --exclude-dir={.git,.svn}'
alias ssh='ssh -X'

alias gdf="git difftool -t vimdiff"
alias gdn="git diff --name-only"

git config --global core.excludesfile '~/workspace/dotfiles/gitignore'
git config --global diff.tool vimdiff
git config --global difftool.prompt true
git config --global merge.tool vimdiff2     # tool: vimdiff, vimdiff2, vimdiff3
git config --global mergetool.prompt true
git config --global merge.conflictstyle diff3   # confilctstyle: merge, diff3

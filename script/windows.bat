set DOTFILES=%USERPROFILE%/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc"    "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc"    "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.pylintrc" "%DOTFILES%/conf/pylintrc"

mklink /d "%USERPROFILE%/vimfiles/after" "%DOTFILES%/conf/vim-after"


choco install -y wget
choco install -y vim-tux
choco install -y python3
choco install -y sourcetree
choco install -y cmder
choco install -y babun

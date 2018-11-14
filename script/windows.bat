set DOTFILES=%USERPROFILE%/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc"    "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc"    "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.pylintrc" "%DOTFILES%/conf/pylintrc"

mklink /d "%USERPROFILE%/.vim/after" "%DOTFILES%/conf/vim-after"

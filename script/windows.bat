set DOTFILES=%USERPROFILE%/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc"    "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc"    "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.pylintrc" "%DOTFILES%/conf/pylintrc"

mklink /d "%USERPROFILE%/vimfiles/after" "%DOTFILES%/conf/vim-after"

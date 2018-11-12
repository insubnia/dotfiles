set DOTFILES=%USERPROFILE%/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc"    "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.pylintrc" "%DOTFILES%/conf/pylintrc"

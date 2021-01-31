:: set DOTFILES=%USERPROFILE%/workspace/dotfiles
set DOTFILES=D:/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc" "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc" "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.flake8" "%DOTFILES%/conf/flake8"
REM  mklink /D "%USERPROFILE%/.vim" "%USERPROFILE%/vimfiles"
mklink "%USERPROFILE%/Desktop/ip-shift.bat" "%DOTFILES%/script/windows-ip-shift.bat"

mkdir "%USERPROFILE%/AppData/Local/nvim"
mklink "%USERPROFILE%/AppData/Local/nvim/init.vim" "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/AppData/Local/nvim/ginit.vim" "%DOTFILES%/vim/ginit.vim"

mkdir "%APPDATA%/Code/User"
mklink "%APPDATA%/Code/User/settings.json" "%DOTFILES%/vscode/settings.json"
mklink "%APPDATA%/Code/User/keybindings.json" "%DOTFILES%/vscode/keybindings.json"

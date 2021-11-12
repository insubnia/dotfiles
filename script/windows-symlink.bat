@echo off
set DOTFILES=%USERPROFILE%/workspace/dotfiles

pushd .

:: ~
cd %USERPROFILE%
del /f _vimrc .ackrc .flake8

mklink "%USERPROFILE%/_vimrc" "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc" "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.flake8" "%DOTFILES%/conf/flake8"
mklink "%USERPROFILE%/.gitignore" "%DOTFILES%/conf/gitignore"
::mklink "%USERPROFILE%/Desktop/ip-shift.bat" "%DOTFILES%/script/windows-ip-shift.bat"


:: ~/AppData/Local/nvim
set NVIM_DIR=%LOCALAPPDATA%/nvim
mkdir "%NVIM_DIR%" & cd %NVIM_DIR%
del /f init.vim ginit.vim

mklink "%NVIM_DIR%/init.vim" "%DOTFILES%/vimrc"
mklink "%NVIM_DIR%/ginit.vim" "%DOTFILES%/vim/ginit.vim"


:: ~/AppData/Roaming/Code/User
set VSCODE_DIR=%APPDATA%/Code/User
mkdir "%VSCODE_DIR%" & cd %VSCODE_DIR%
del /f settings.json keybindings.json

mklink "%VSCODE_DIR%/settings.json" "%DOTFILES%/vscode/settings.json"
mklink "%VSCODE_DIR%/keybindings.json" "%DOTFILES%/vscode/keybindings.json"

popd

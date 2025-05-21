:: mklink /d "%USERPROFILE%/workspace" "D:/workspace"

@echo off
set DOTFILES=%USERPROFILE%/workspace/dotfiles

pushd .

:: ~
cd %USERPROFILE%
del /f _vimrc

mklink "%USERPROFILE%/_vimrc" "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.gitignore" "%DOTFILES%/conf/gitignore"
::mklink "%USERPROFILE%/Desktop/ip-shift.bat" "%DOTFILES%/script/windows-ip-shift.bat"


:: ~/AppData/Local/nvim
set NVIM_DIR=%LOCALAPPDATA%/nvim
md "%NVIM_DIR%" & cd %NVIM_DIR%
del /f init.vim ginit.vim
mklink "%NVIM_DIR%/init.vim" "%DOTFILES%/vimrc"
mklink "%NVIM_DIR%/ginit.vim" "%DOTFILES%/vim/ginit.vim"

set NVIM_LUA_DIR=%LOCALAPPDATA%/nvim/lua
md "%NVIM_LUA_DIR%" & cd %NVIM_LUA_DIR%
del /f init.lua
mklink "%NVIM_LUA_DIR%/init.lua" "%DOTFILES%/init.lua"


:: ~/AppData/Roaming/Code/User
set VSCODE_DIR=%APPDATA%/Code/User
md "%VSCODE_DIR%" & cd %VSCODE_DIR%
del /f settings.json keybindings.json

mklink "%VSCODE_DIR%/settings.json" "%DOTFILES%/vscode/settings.json"
mklink "%VSCODE_DIR%/keybindings.json" "%DOTFILES%/vscode/keybindings.json"
del /f "%VSCODE_DIR%/snippets"
mklink /d "%VSCODE_DIR%/snippets" "%DOTFILES%/vim/snippets"

popd

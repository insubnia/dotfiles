set DOTFILES=%USERPROFILE%/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc" "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc" "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.flake8" "%DOTFILES%/conf/flake8"
REM  mklink /D "%USERPROFILE%/.vim" "%USERPROFILE%/vimfiles"

REM  tool
choco install -y chocolateygui
choco install -y googlechrome
choco install -y onedrive
choco install -y flashplayerplugin
choco install -y vlc
choco install -y vim
choco install -y sourcetree
choco install -y vscode
choco install -y tortoisegit

REM server
choco install -y openssh
choco install -y putty

REM  dev
choco install -y git
choco install -y ack
choco install -y llvm
choco install -y make
choco install -y ctags
choco install -y cmake
choco install -y python3
choco install -y nodejs
choco install -y wget
choco install -y dos2unix

REM  font
choco install -y d2codingfont

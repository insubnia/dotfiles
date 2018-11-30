set DOTFILES=%USERPROFILE%/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc" "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc" "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.flake8" "%DOTFILES%/conf/flake8"

REM  tool
choco install -y chocolateygui
choco install -y git
choco install -y vim-tux
choco install -y sourcetree
choco install -y cmder
choco install -y babun

REM  dev
choco install -y ack
choco install -y llvm
choco install -y ctags
choco install -y cmake
choco install -y python3
choco install -y nodejs
choco install -y wget

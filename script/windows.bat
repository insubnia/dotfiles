set DOTFILES=%USERPROFILE%/workspace/dotfiles

mklink "%USERPROFILE%/_vimrc"    "%DOTFILES%/vimrc"
mklink "%USERPROFILE%/.ackrc"    "%DOTFILES%/conf/ackrc"
mklink "%USERPROFILE%/.pylintrc" "%DOTFILES%/conf/pylintrc"

mklink /d "%USERPROFILE%/vimfiles/after" "%DOTFILES%/conf/vim-after"

REM  tool
choco install -y git
choco install -y vim-tux
choco install -y sourcetree
choco install -y cmder
choco install -y babun

REM  dev
choco install -y ack
choco install -y ctags
choco install -y python3
choco install -y nodejs
choco install -y wget

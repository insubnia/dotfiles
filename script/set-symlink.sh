#!/bin/bash

DOTFILES=~/workspace/dotfiles
CONF=$DOTFILES/conf
VSCODE=$DOTFILES/vscode

# TAR=~/.ctags.d/default.ctags
# if [ ! -e $TAR ]; then
#     mkdir -p $(dirname $TAR)
#     ln -sf $CONF/ctags $TAR
#     echo Make universal-ctags symlink
# else
#     echo default.ctags already exists
# fi

ln -sf $CONF/ackrc ~/.ackrc
ln -sf $CONF/tigrc ~/.tigrc
ln -sf $CONF/ctags ~/.ctags
ln -sf $CONF/flake8 ~/.flake8

case "$OSTYPE" in
    darwin*)
        VSCODE_USER=~/Library/Application\ Support/Code/User
        ;;
    linux*)
        VSCODE_USER=~/.config/Code/User
        ;;
esac

ln -sf $VSCODE/settings.json $VSCODE_USER/settings.json
ln -sf $VSCODE/keybindings.json $VSCODE_USER/keybindings.json

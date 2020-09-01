#!/bin/bash

DOTFILES=~/workspace/dotfiles
CONF=~/workspace/dotfiles/conf

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
        ln -sf $DOTFILES/settings.json ~/Library/Application\ Support/Code/User/settings.json
        ;;
    linux*)
        ln -sf $DOTFILES/settings.json ~/.config/Code/User/settings.json
        ;;
esac

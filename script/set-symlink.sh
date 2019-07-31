#!/bin/bash

CONF=~/workspace/dotfiles/conf

TAR=~/.ctags.d/default.ctags
if [ ! -e $TAR ]; then
    mkdir -p $(dirname $TAR)
    ln -sf $CONF/ctags $TAR
    echo Make universal-ctags symlink
else
    echo default.ctags already exists
fi

# exuberant-ctags
ln -sf $CONF/ackrc ~/.ackrc
ln -sf $CONF/tigrc ~/.tigrc
ln -sf $CONF/ctags ~/.ctags
ln -sf $CONF/flake8 ~/.flake8

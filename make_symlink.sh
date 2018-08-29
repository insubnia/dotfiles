#!/bin/bash

DOTFILES=$HOME/workspace/dotfiles

TAR=$HOME/.ctags
if [ ! -e $TAR ]; then
    ln -s $DOTFILES/ctags $TAR
    echo Make exuberant-ctags symlink
else
    echo .ctags already exists
fi

TAR=$HOME/.ctags.d/default.ctags
if [ ! -e $TAR ]; then
    mkdir -p $(dirname $TAR)
    ln -s $DOTFILES/ctags $TAR
    echo Make universal-ctags symlink
else
    echo default.ctags already exists
fi

TAR=$HOME/.ackrc
if [ ! -e $TAR ]; then
    ln -s $DOTFILES/ackrc $TAR
    echo Make ackrc symlink
else
    echo .ackrc already exists
fi

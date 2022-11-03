#!/bin/bash

DOTFILES=~/workspace/dotfiles
CONF=$DOTFILES/conf
VSCODE=$DOTFILES/vscode

ln -sf $CONF/flake8 ~/.flake8
ln -sf $CONF/tmux.conf ~/.tmux.conf

mkdir -p ~/.config/fd
ln -sf $CONF/fdignore ~/.config/fd/ignore

case "$OSTYPE" in
    darwin*)
        VSCODE_USER=~/Library/Application\ Support/Code/User
        ;;
    linux*)
        VSCODE_USER=~/.config/Code/User
        ;;
esac

mkdir -p $VSCODE_USER
ln -sf $VSCODE/settings.json $VSCODE_USER/settings.json
ln -sf $VSCODE/keybindings.json $VSCODE_USER/keybindings.json

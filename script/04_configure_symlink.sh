#!/bin/bash

DOTFILES=~/workspace/dotfiles
CONF=$DOTFILES/conf
VSCODE=$DOTFILES/vscode

ln -sf $CONF/tmux.conf ~/.tmux.conf

mkdir -p ~/.config/fd
ln -sf $CONF/fdignore ~/.config/fd/ignore

case "$OSTYPE" in
    darwin*)
        VSCODE_USER=~/Library/Application\ Support/Code/User
        ;;
    linux*)
        VSCODE_USER=~/.config/Code/User
        sudo ln -sf $(which fdfind) /usr/bin/fd
        ;;
esac

mkdir -p $VSCODE_USER
ln -sf $VSCODE/settings.json $VSCODE_USER/settings.json
ln -sf $VSCODE/keybindings.json $VSCODE_USER/keybindings.json

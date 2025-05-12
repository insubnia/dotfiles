#!/bin/bash

DOTFILES=$HOME/workspace/dotfiles
CONF=$DOTFILES/conf
VSCODE=$DOTFILES/vscode

ln -sf $CONF/tmux.conf $HOME/.tmux.conf
ln -sf $CONF/ripgreprc $HOME/.ripgreprc

mkdir -p $HOME/.config/fd
ln -sf $CONF/fdignore $HOME/.config/fd/ignore

# python
# ln -sf $CONF/pyrightconfig.json ~/.pyrightconfig.json
# mkdir -p ~/.config/pyright
# ln -sf $CONF/pyrightconfig.json ~/.config/pyright/config.json

# vscode
case "$OSTYPE" in
    darwin*)
        VSCODE_USER=~/Library/Application\ Support/Code/User
        ;;
    linux*)
        VSCODE_USER=~/.config/Code/User
        # sudo ln -sf $(which fdfind) /usr/bin/fd
        ;;
esac
mkdir -p $VSCODE_USER
ln -sf $VSCODE/settings.json $VSCODE_USER/settings.json
ln -sf $VSCODE/keybindings.json $VSCODE_USER/keybindings.json

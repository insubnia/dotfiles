#!/bin/bash
if [ -z "$DOTFILES" ]; then
    DOTFILES="$(dirname $(dirname $(realpath "$0")))"
fi

# vim
VIM=~/.vim
mkdir -p $VIM
ln -sf $DOTFILES/vimrc ~/.vimrc

# ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# neovim
NVIM=~/.config/nvim
mkdir -p $NVIM $NVIM/lua
ln -sf $DOTFILES/vimrc $NVIM/init.vim
ln -sf $DOTFILES/init.lua $NVIM/lua/init.lua

# ~/.config/nvim/autoload
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

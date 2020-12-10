#!/bin/bash

DOTFILES=~/workspace/dotfiles

# Vim
VIM=~/.vim
mkdir -p $VIM
ln -sf $DOTFILES/vimrc ~/.vimrc

# ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# NeoVim
NVIM=~/.config/nvim
mkdir -p $NVIM
ln -sf $DOTFILES/vimrc $NVIM/init.vim

# ~/.config/nvim/autoload
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

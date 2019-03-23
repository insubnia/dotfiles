#!/bin/bash

DOTFILES=~/workspace/dotfiles

ln -sf $DOTFILES/vimrc ~/.vimrc

# Vim (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

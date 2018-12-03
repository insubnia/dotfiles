#!/bin/bash

DOTFILES=~/workspace/dotfiles

ln -sf $DOTFILES/vimrc ~/.vimrc

# Vundle & Plugin install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e "cloning Vundle\n"
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
else
    echo Vundle already exists
fi

vim +PluginInstall +qall

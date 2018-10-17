#!/bin/bash

DOTFILES=$HOME/workspace/dotfiles

if [ ! -e $HOME/.vimrc ]; then
    ln -sf $DOTFILES/vimrc $HOME/.vimrc
    echo Make .vimrc symlink
else
    echo vimrc already exists
fi

if [ ! -d $HOME/.vim/after ]; then
    ln -sf $DOTFILES/after $HOME/.vim/after
    echo Make .vim/after symlink
else
    echo after dir already exists
fi

# Vundle & Plugin install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e "cloning Vundle\n"
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
else
    echo Vundle already exists
fi

vim +PluginInstall +qall

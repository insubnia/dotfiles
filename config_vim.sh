#!/bin/bash
# configuration for VIM

DIR=$PWD

# Making symbolic link of vimrc
if [ ! -e ~/.vimrc ]; then
    echo -e "making vimrc symlink\n"
    cd ~
    ln -s $DIR/vimrc .vimrc
    cd - > /dev/null
else
    echo vimrc already exist!
fi

# Making symbolic link of after directory
if [ ! -d ~/.vim/after ]; then
    echo -e "making after ftplugin symlink\n"
    cd ~/.vim/
    ln -s $DIR/after/ after
    cd - > /dev/null
else
    echo after dir already exist!
fi

# Vundle & Plugin install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e "cloning Vundle\n"
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
    vim -c PluginInstall -c qa
else
    echo Vundle already exist!
fi


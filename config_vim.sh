#!/bin/bash

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
    echo after directory already exist!
fi

# Configure ycm_extra_config file
if [ ! -e ~/.vim/.ycm_extra_conf.py ]; then
    echo -e "making ycm_extra_conf symlink"
    cd ~/.vim/
    ln -s $DIR/ycm_extra_conf.py .ycm_extra_conf.py
    cd - > /dev/null
else
    echo ycm_extra_conf already exist!
fi

# Vundle & Plugin install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e "cloning Vundle\n"
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
    vim -c PluginInstall -c qa
else
    echo Vundle already exist!
fi

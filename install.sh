#!/bin/bash

echo -e "\nsis shell install script\n"

echo -e "Update & upgrade apt packages"
sudo apt-get -y update > /dev/null
sudo apt-get -y upgrade > /dev/null
sudo apt-get -y autoremove > /dev/null

# -e option enables escape letter
echo -e "\n[Installing packages]\n"

# Ubuntu package install
while read -r p
do
    echo -e "Installing $p"
    sudo apt-get install -y $p > /dev/null
    echo -e "Done!"
done < <(cat << EOF
   git
   gnome-terminal
   tree
   make
   cmake
   powerline
   exuberant-ctags
   fonts-nanum-coding
   python3
EOF
)

# Python package install
while read -r p
do
    echo -e "Installing python package $p"
    sudo apt-get install -y python3-$p > /dev/null
    sudo -H python3 -mpip install -U $p > /dev/null
    echo -e "Done!"
done < <(cat << EOF
    pip
    numpy
    scipy
    matplotlib
EOF
)
sudo -H python3 -mpip install -U python-config

# Vundle install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e cloning Vundle\n
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
fi

echo -e "\n[Installation complete!!]\n"

#export DISPLAY=:0
#source /usr/share/powerline/bindings/bash/powerline.sh
#alias python='usr/bin/python3'


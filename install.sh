#!/bin/bash

echo -e "\nsis shell install script\n"

echo -e "Update & upgrade apt packages"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove

# -e option enables escape letter
echo -e "\n[Installing packages]\n"

# Ubuntu package install
while read line
do
    echo -e "\nInstalling $line"
    sudo apt-get install -y $line
done < <(cat << EOF
    zsh
    gcc
    git
    wget
    tree
    make
    cmake
    cscope
    xclip
    autojump
    powerline
    dconf-cli
    exuberant-ctags
    python3
    python3-tk
    python3-pip
    python-dev
    python3-dev
EOF
)

# Python package install
while read line
do
    echo -e "\nInstalling python package - $line"
    sudo -H python3 -mpip install -U $line
done < <(cat << EOF
    numpy
    scipy
    matplotlib
    python-config
EOF
)

echo -e "\n[Installation complete!!]\n"


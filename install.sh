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
done < <(cat << EOF
    gcc
    git
    tree
    make
    cmake
    ctags
    cscope
    xclip
    powerline
    exuberant-ctags
    fonts-nanum-coding
    python3
    python3-tk
    python3-pip
    libboost-all-dev
EOF
)

# Python package install
while read -r p
do
    echo -e "Installing python package - $p"
    sudo -H python3 -mpip install -U $p > /dev/null
done < <(cat << EOF
    numpy
    scipy
    matplotlib
    python-config
    flake8
EOF
)

echo -e "\n[Installation complete!!]\n"


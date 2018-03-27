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
    gcc
    git
    tree
    make
    cmake
    ctags
    cscope
    xclip
    powerline
    dconf-cli
    exuberant-ctags
    fonts-nanum-coding
    python3
    python3-tk
    python3-pip
    python-dev
    python3-dev
    libboost-all-dev
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


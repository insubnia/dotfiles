#!/bin/bash

case "$OSTYPE" in
    darwin*) pm="brew" ;;
    linux*) pm="apt-get" ;;
esac

# # -e option enables escape letter
echo -e "\nsis shell install script"

echo -e "\n[Update & upgrade packages]"
$pm update
$pm upgrade

# Install packages using package manager
while read line
do
    echo -e "\n[Installing $line]"
    $pm install -y $line
done < <(cat << EOF
    zsh
    gcc
    git
    wget
    tree
    make
    cmake
    ctags
    python3
    python3-pip
    autojump
    fzf
EOF
)

# Python package install
while read line
do
    echo -e "\n[Installing $line]"
    sudo -H pip3 install -U $line
done < <(cat << EOF
    pip 
    numpy
    scipy
    matplotlib
    pyqt5
EOF
)

echo -e "\n\nInstallation complete!!\n"

#!/bin/bash

case "$OSTYPE" in
    darwin*) pm="brew" ;;
    linux*) pm="sudo apt-get" ;;
esac

echo -e "\nsis shell install script\n"

echo -e "Update & upgrade packages"
$pm update
$pm upgrade

# # -e option enables escape letter
echo -e "\n[Installing packages]\n"

# Install packages using package manager
while read line
do
    echo -e "\nInstalling $line"
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
    autojump
    python3
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


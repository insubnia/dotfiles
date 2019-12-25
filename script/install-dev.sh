#!/bin/bash

case "$OSTYPE" in
    darwin*)
        pm="brew"
        ;;
    linux*)
        if [ $EUID != 0 ]; then
            echo -e "\nThis script must be run as root\n\nTerminate the script\n"
            return
        fi
        pm='apt -y'
        ;;
esac

echo -e "\n[Update & upgrade packages]"
eval $pm update
eval $pm upgrade

while read line
do
    echo -e "\n[Installing $line]"
    eval $pm install $line
done < <(cat << EOF
    gcc
    git
    git-flow
    tig
    wget
    tree
    make
    cmake
    scons
    ctags
    python3
    ack
    autojump
    unrar
    nodejs
    npm
    llvm
    dos2unix
    libxml2
EOF
)

echo -e "\n[Cloning color schemes]"
git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git ~/workspace/colorschemes

# Install list depending on OS
macos_list=(
    binutils
    coreutils
)

linux_list=(
)

case "$OSTYPE" in
    darwin*) list=($macos_list) ;;
    linux*) list=($linux_list) ;;
esac

for item in $list
do
    echo -e "\n[Installing $item]"
    eval $pm install $item
done

echo -e "\nComplete\n"

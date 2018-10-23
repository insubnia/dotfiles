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
        pm="apt-get"
        ;;
esac

echo -e "\n[Update & upgrade packages]"
$pm update
$pm upgrade

while read line
do
    echo -e "\n[Installing $line]"
    $pm install -y $line
done < <(cat << EOF
    gcc
    git
    wget
    tree
    make
    cmake
    ctags
    python3
    python3-pip
    ack
    autojump
    fzf
    unrar
    nodejs
    npm
EOF
)

echo -e "\nComplete\n"

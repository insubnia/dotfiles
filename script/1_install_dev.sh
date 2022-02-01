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
# eval $pm update
# eval $pm upgrade

# common=(
list=(
    neovim
    git
    git-flow
    tig
    ack
    bat
    tmux
    wget
    curl
    tree
    gcc
    llvm
    clang-format
    make
    cmake
    scons
    python3
    pyenv
    autojump
    p7zip
    node
    nodejs
    jq
    npm
    dos2unix
    libxml2
    java
    iperf3
    htop
    tcpdump
    meld
)

macos=(
    iterm2
    github
    binutils
    coreutils
    fd
    mas
    autojump
)

linux=(
    vim-gtk
    xclip
    python3-pip
    clang
    clangd
    libclang-dev
    net-tools
    fd-find
)

case "$OSTYPE" in
    darwin*) list+=($macos) ;;
    linux*) list+=($linux) ;;
esac

for item in $list
do
    echo -e "\n[Installing $item]"
    eval $pm install $item
done

echo -e "\nComplete\n"

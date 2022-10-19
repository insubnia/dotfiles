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

list=(
    neovim
    git
    git-flow
    tig
    bat
    tmux
    wget
    curl
    tree
    fzf
    gcc
    llvm
    clang-format
    lld
    make
    bear  # C/C++ compilation database generater
    cmake
    scons
    python3
    autojump
    p7zip
    rar
    nodejs
    jq
    npm
    lua
    dos2unix
    libxml2
    iperf3
    htop
    tcpdump
    # meld
    lsusb
    qt
)

macos=(
    the_silver_searcher
    mas
    github
    binutils
    coreutils
    node
    nvm
    pyenv
    ta-lib
    fd
)

linux=(
    silversearcher-ag
    vim-gtk
    xclip
    python3-pip
    clang
    clangd
    libclang-dev
    net-tools
    fd-find
    gcc-arm-none-eabi
)

case "$OSTYPE" in
    darwin*) list+=(${macos[@]}) ;;
    linux*) list+=(${linux[@]}) ;;
esac

for v in ${list[@]}
do
    echo -e "\n[Installing $item]"
    eval $pm install $v
done

echo -e "\nComplete\n"

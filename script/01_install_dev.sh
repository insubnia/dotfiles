#!/bin/bash

case "$OSTYPE" in
    darwin*)
        pm="brew"
        ;;
    linux*)
        pm='apt -y'
        if [ $EUID != 0 ]; then
            echo -e "You must run this script with sudo\n"
            return
        fi
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
    dos2unix
    imagemagick
    libxml2
    iperf3
    htop
    tcpdump
    # meld
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
    lua
    fd
    qt
    lsusb
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
    wireshark
    peek
)

apt_repos=(
    ppa:peek-developers/stable
    ppa:neovim-ppa/stable
)

case "$OSTYPE" in
    darwin*)
        list+=(${macos[@]})
        ;;
    linux*)
        list+=(${linux[@]})
        for v in ${apt_repos[@]}
        do
            eval add-apt-repository $v
        done
        eval $pm update
        ;;
esac

for v in ${list[@]}
do
    echo -e "\n[Installing $item]"
    eval $pm install $v
done

echo -e "\nComplete\n"

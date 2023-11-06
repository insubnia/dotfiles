#!/bin/bash

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
    ccache
    bear
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
    caffeine
)

# OS variant
macos=(
    the_silver_searcher
    mas
    github
    binutils
    coreutils
    node
    nvm
    ta-lib
    lua
    fd
    qt
    lsusb
    # C/C++
    boost
    # python
    autopep8
    pyenv
    # for fun
    nyancat
    cmatrix
    asciiquarium
)
linux=(  # https://packages.ubuntu.com/
    silversearcher-ag
    vim-gtk
    xclip
    net-tools
    fd-find
    wireshark
    minicom
    cutecom
    peek
    samba
    ufw
    beep
    # C/C++
    gcc-arm-none-eabi
    clang
    clangd
    libclang-dev
    libboost-all-dev
    # python
    python3-pip
    python3-autopep8
    # for fun
    nyancat
    cmatrix
)
apt_repos=(
    ppa:peek-developers/stable
    ppa:neovim-ppa/stable
)


case "$OSTYPE" in
    darwin*)
        pm="brew"
        list+=(${macos[@]})
        ;;

    linux*)
        pm='apt-get -y'
        list+=(${linux[@]})
        if [ $EUID != 0 ]; then
            echo -e "You must run this script with sudo\n"
            return
        fi

        echo -ne "\nAdding PPAs(Personal Package Archive)... "
        for v in ${apt_repos[@]}
        do
            eval add-apt-repository -y $v > /dev/null
        done
        echo -e "Done\n"
        ;;
esac


echo -ne "\nUpdating & Upgrading packages... "
eval $pm update > /dev/null
eval $pm upgrade > /dev/null
echo -e "Done\n"


for v in ${list[@]}
do
    echo -n "Installing $v... "
    eval $pm install $v > /dev/null
    echo -e "Done"
done

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo -e "\nComplete\n"

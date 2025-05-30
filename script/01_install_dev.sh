#!/bin/bash

# Common list
list=(
    neovim
    git
    git-flow
    tmux
    zsh
    fish
    tig
    bat
    wget
    curl
    tree
    dos2unix
    tldr
    # search
    fzf
    ripgrep
    # C/C++
    gcc
    llvm
    clang-format
    lld
    make
    ccache
    bear
    cmake
    scons
    # Python
    python3
    # utilities
    autojump
    caffeine
    neofetch
    # etc
    nodejs
    npm
    p7zip
    rar
    jq
    imagemagick
    libxml2
    iperf3
    htop
    tcpdump
)

# OS variant
macos=(
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
    # Python
    autopep8
    # JAVA
    openjdk
    # for fun
    nyancat
    cmatrix
    asciiquarium
)
linux=(  # https://packages.ubuntu.com/
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
    x11-apps
    x11-utils
    xrdp
    dbus-x11
    # C/C++
    gcc-arm-none-eabi
    clang
    clangd
    libclang-dev
    libboost-all-dev
    # Python
    python3-pip
    python3-autopep8
    # JAVA
    default-jre
    default-jdk
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

echo -e "\nComplete\n"

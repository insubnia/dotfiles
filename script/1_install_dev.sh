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
done << EOF
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
    unrar
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
EOF

# echo -e "\n[Cloning color schemes]"
# git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git ~/workspace/colorschemes

# Install list depending on OS
macos_list=(
    iterm2
    github
    binutils
    coreutils
    fd
    mas
)

linux_list=(
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
    darwin*) list=${macos_list[@]} ;;
    linux*) list=${linux_list[@]} ;;
esac

for item in $list
do
    echo -e "\n[Installing $item]"
    eval $pm install $item
done

echo -e "\nComplete\n"

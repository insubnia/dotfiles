#!/bin/bash

# At first, install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install apps
while read line
do
    brew install --cask $line
done << EOF
    karabiner-elements
    scroll-reverser
    appcleaner
    iterm2
    google-chrome
    onedrive
    vlc
    folx
    mounty
    sourcetree
    visual-studio-code
    wireshark
    mas
    gcc-arm-embedded
EOF

# https://github.com/mas-cli/mas
mas install 869223134  # KakaoTalk
mas install 1236050766 # Melon
mas install 441258766  # Magnet
mas install 1471801525 # polyglot
mas install 1231935892 # Unicorn
mas install 1475628500 # Unicorn HTTPS
mas install 1033453958 # AllDic
mas install 1594059167 # NflxMultiSubs
mas install 1153157709 # Speedtest

# Install fonts
brew tap homebrew/cask-fonts
while read line
do
    brew install --cask $line
done << EOF
    font-d2coding
    font-hack-nerd-font
EOF

echo -e "\nComplete\n"

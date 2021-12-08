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
EOF

mas install 869223134  # kakaotalk
mas install 441258766  # magnet

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

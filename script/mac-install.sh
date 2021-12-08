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
    transmission
    mounty
    sourcetree
    visual-studio-code
    wireshark
EOF

# Install fonts
brew tap homebrew/cask-fonts
while read line
do
    brew cask install $line
done << EOF
    font-d2coding
    font-hack-nerd-font-mono
EOF

echo -e "\nComplete\n"

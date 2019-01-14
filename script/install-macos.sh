#!/bin/bash

# At first, install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install apps
while read line
do
    brew cask install $line
done < <(cat << EOF
    karabiner-elements
    appcleaner
    iterm2
    google-chrome
    onedrive
    flash-npapi
    vlc
    folx
    mounty
    sourcetree
    visual-studio-code
EOF
)

# Install fonts
brew tap homebrew/cask-fonts
while read line
do
    brew cask install $line
done < <(cat << EOF
    font-d2coding
    font-hack-nerd-font
EOF
)

echo -e "\nComplete\n"

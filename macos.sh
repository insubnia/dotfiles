#!/bin/bash

# At first, install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

while read line
do
    brew cask install $line
done < <(cat << EOF
    iterm2
    sourcetree
    karabiner-elements
    appcleaner
    flash-npapi
    vlc
    folx
    mounty
EOF
)

brew tap homebrew/cask-fonts
while read line
do
    brew cask install $line
done < <(cat << EOF
    font-d2coding
    font-hack-nerd-font
EOF
)

echo -e "\n\nInstallation complete\n\n"

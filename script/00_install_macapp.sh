#!/bin/bash

# Install Homebrew🍺
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

apps=(
    iterm2
    karabiner-elements
    scroll-reverser
    appcleaner
    google-chrome
    onedrive
    vlc
    folx
    adobe-acrobat-reader
    mounty
    sourcetree
    smartgit
    visual-studio-code
    wireshark
    gcc-arm-embedded
)

fonts=(
    font-d2coding
    font-dejavusansmono-nerd-font-mono
    font-meslo-lg-nerd-font
)

# https://github.com/mas-cli/mas
mas_list=(
    869223134  # KakaoTalk
    1236050766 # Melon
    441258766  # Magnet
    1471801525 # polyglot
    1231935892 # Unicorn
    1475628500 # Unicorn HTTPS
    1033453958 # AllDic
    1594059167 # NflxMultiSubs
    1153157709 # Speedtest
)


for v in ${apps[@]}
do
    brew install --cask $v
done

brew tap homebrew/cask-fonts
for v in ${fonts[@]}
do
    brew install --cask $v
done

for v in ${mas_list[@]}
do
    mas install $v
done

echo -e "\nComplete\n"

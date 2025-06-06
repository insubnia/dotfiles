#!/bin/bash

# Install Homebrew🍺
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

apps=(
    # essential
    iterm2
    appcleaner
    onedrive
    adobe-acrobat-reader
    vlc
    folx
    notion
    google-chrome

    # dev
    sourcetree
    visual-studio-code
    docker
    # qt-creator

    # paid
    soundsource

    # productivity
    karabiner-elements
    scroll-reverser
    hiddenbar
    stats
    monitorcontrol

    # embedded
    gcc-arm-embedded
    # coolterm

    # etc
    cron
    drawio
    mounty
    wireshark
)

# https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e
# https://www.nerdfonts.com/font-downloads
fonts=(
    font-jetbrains-mono-nerd-font
    font-dejavu-sans-mono-nerd-font
    font-meslo-lg-nerd-font
    font-d2coding-nerd-font
)

# https://github.com/mas-cli/mas
# mas search {AppName}
mas_list=(
    869223134  # KakaoTalk
    1236050766 # Melon
    441258766  # Magnet
    418073146  # Snap
    1471801525 # polyglot
    1231935892 # Unicorn
    1475628500 # Unicorn HTTPS
    1033453958 # AllDic
    1594059167 # NflxMultiSubs
    1153157709 # Speedtest
)


for v in ${apps[@]}
do
    echo -n "Installing $v... "
    brew install --cask $v > /dev/null
    echo -e "Done"
done

brew tap homebrew/cask-fonts
for v in ${fonts[@]}
do
    echo -n "Installing $v... "
    brew install --cask $v > /dev/null
    echo -e "Done"
done

for v in ${mas_list[@]}
do
    mas install $v
done

echo -e "\nComplete\n"

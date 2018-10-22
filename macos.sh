#!/bin/bash
# installation with homebrew

while read line
do
    echo -e "\n[Installing $line]"
    # brew cask install
    echo $line
done < <(cat << EOF
    iterm2
    sourcetree
    font-hack-nerd-font
    folx
    mounty
EOF
)

echo -e "\n\nInstallation complete!!\n"

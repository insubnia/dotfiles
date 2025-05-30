#!/bin/bash

apps=(
    code
    gitkraken
    office365webdesktop
    emote
)
fonts=(
    fonts-jetbrains-mono
    fonts-naver-d2coding
    fonts-nanum
)


for v in ${apps[@]}
do
    snap install --classic $v
done

fc-cache -fv &> /dev/null
for v in ${fonts[@]}
do
    sudo apt install $v
done

echo -e "\nComplete\n"

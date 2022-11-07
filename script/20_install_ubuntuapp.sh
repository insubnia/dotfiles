#!/bin/bash

apps=(
    code
    gitkraken
    office365webdesktop
    skype
)

for v in ${apps[@]}
do
    snap install --classic $v
done

echo -e "\nComplete\n"


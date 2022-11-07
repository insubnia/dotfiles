#!/bin/bash

apps=(
    code
    gitkraken
    skype
)

for v in ${apps[@]}
do
    snap install --classic $v
done

echo -e "\nComplete\n"


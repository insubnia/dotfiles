#!/bin/bash

echo -e "\nInstall python packages"

while read line
do
    echo -e "\n[Installing $line]"
    sudo -H pip3 install -U $line
done < <(cat << EOF
    pip 
    numpy
    scipy
    matplotlib
    pyqt5
EOF
)

echo -e "\nComplete\n"

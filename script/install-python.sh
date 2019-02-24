#!/bin/bash

if [ ! -x $(which pip) ]; then
    if [[ $OSTYPE == linux* ]]; then
        echo -e "\nInstall pip3 first"
        sudo apt-get install python3-pip
    fi
fi

echo -e "\nInstall python packages"

while read line
do
    echo -e "\n[Install & Upgrade $line]"
    python3 -m pip install -U --user $line
done < <(cat << EOF
    pip
    flake8
    pep8-naming
    autopep8
    numpy
    scipy
    matplotlib
    pyqt5
    pyinstaller
EOF
)

echo -e "\nComplete\n"

#!/bin/bash

if [ ! -x $(which pip) ]; then
    if [[ $OSTYPE == linux* ]]; then
        echo -e "\nInstall pip3 first"
        sudo apt install python3-pip
    fi
fi

echo -e "\nInstall python packages"

while read line
do
    echo -e "\n[Install & Upgrade $line]"
    python3 -m pip install -U --user $line
done << EOF
    pip
    flake8
    pep8-naming
    autopep8
    numpy
    scipy
    matplotlib
    mplfinance
    pyqt5
    pyinstaller
    pandas
    python-language-server
    pynvim
    compiledb
    cmake_format
    tqdm
    colorama
    argparse
    beautifulsoup4
    requests
    pyjwt
EOF

echo -e "\nComplete\n"

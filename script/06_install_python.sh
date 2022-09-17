#!/bin/bash

if [ ! -x $(which pip) ]; then
    if [[ $OSTYPE == linux* ]]; then
        echo -e "\nInstall pip3 first"
        sudo apt install python3-pip
    fi
fi

echo -e "\nInstall python packages"

list=(
    pip
    pyright
    flake8
    pep8
    pep8-naming
    autopep8
    numpy
    scipy
    matplotlib
    mplfinance
    pyqt6
    pyinstaller
    pandas
    pandas_ta
    ta-lib
    python-language-server
    pynvim
    torch
    compiledb
    cmake_format
    tqdm
    colorama
    argparse
    beautifulsoup4
    requests
    pyjwt
    selenium
)

for item in ${list[@]}
do
    # echo -e "\n[Install & Upgrade $item]"
    python3 -m pip install -U --user $item
done

echo -e "\nComplete\n"

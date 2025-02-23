#!/bin/bash
if [[ ! -x $(which pip3) ]]; then
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
    autopep8
    pep8
    pep8-naming
    python-language-server
    selenium
    numpy
    scipy
    matplotlib
    plotly
    pyqt6
    pyinstaller
    polars
    pandas
    pynvim
    torch
    compiledb
    cmake_format
    tqdm
    dill
    colorama
    argparse
    requests
    pyjwt
)

for item in ${list[@]}
do
    # echo -e "\n[Install & Upgrade $item]"
    python3 -m pip install -U --user $item
done

echo -e "\nComplete\n"

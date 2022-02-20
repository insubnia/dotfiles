#!/bin/bash

MY=~/workspace/dotfiles/wireshark
WIRESHARK=~/.config/wireshark

ln -sf $MY/hosts $WIRESHARK/hosts
ln -sf $MY/dfilter_buttons $WIRESHARK/dfilter_buttons

mkdir -p $WIRESHARK/plugins
ln -sf $MY/EthDiag.lua $WIRESHARK/plugins/EthDiag.lua

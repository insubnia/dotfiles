#!/bin/bash

case "$OSTYPE" in
    darwin*)
        brew install zsh
        ;;
    linux*)
        sudo apt install zsh
        ;;
esac

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
source ~/.zplug/init.zsh

LINE="source ~/workspace/dotfiles/zshrc"
if ! grep -q $LINE ~/.zshrc; then
    echo "Append line"
    # echo $LINE >> ~/.zshrc
else
    echo "Already exist"
fi

# If below command failed, register "/usr/local/bin/zsh" in "/etc/shells"
# sudo permission is needed to edit "/etc/shells"
# chsh -s $(which zsh)

#!/bin/bash

# install zsh
case "$OSTYPE" in
    darwin*)
        brew install zsh
        ;;
    linux*)
        sudo apt-get install zsh
        ;;
esac

# install oh my zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# custom theme
git clone https://github.com/bhilburn/powerlevel9k.git \
    ~/.oh-my-zsh/custom/themes/powerlevel9k

# custom plugin
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Append source line
LINE="source $HOME/workspace/dotfiles/zshrc.sh"
if ! grep -q $LINE $HOME/.zshrc; then
    echo "Append line"
    echo $LINE >> $HOME/.zshrc
else
    echo "Already exist"
fi

# If below command failed, register "/usr/local/bin/zsh" in "/etc/shells"
# sudo permission is needed to edit "/etc/shells"
chsh -s $(which zsh)

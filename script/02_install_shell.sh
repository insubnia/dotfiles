#!/bin/bash

# LEGACY
# change default shell to zsh; 'chsh -s $(which zsh)'
# If the above command failed, register "/usr/local/bin/zsh" in "/etc/shells"

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
source ~/.zplug/init.zsh

# install tpm(tmux plugin manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install ofm(oh-my-fish)
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

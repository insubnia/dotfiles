# configuration for VIM

# Making symbolic link of .vimrc
if [ ! -e ~/.vimrc ]; then
    cd ~
    ln -s ~/workspace/dotfiles/vimrc .vimrc
    cd - > dev/null
fi

# Making symbolic link
if [ ! -d ~/.vim/after ]; then
    cd ~/.vim/
    ln -s ~/workspace/dotfiles/after/ after
    cd - > dev/null
fi

# Vundle install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e cloning Vundle\n
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
fi


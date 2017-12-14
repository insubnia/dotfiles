# configuration for VIM

DIR=$PWD

# Making symbolic link of vimrc
if [ ! -e ~/.vimrc ]; then
    echo -e making vimrc symlink\n
    cd ~
    ln -s $DIR/vimrc .vimrc
    cd - > /dev/null
fi

# Making symbolic link of after directory
if [ ! -d ~/.vim/after ]; then
    echo -e making after symlink\n
    cd ~/.vim/
    ln -s $DIR/after/ after
    cd - > /dev/null
fi

# Vundle install
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo -e cloning Vundle\n
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
fi


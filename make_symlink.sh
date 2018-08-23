if [ ! -e ~/.ctags ]; then
    ln -s $HOME/workspace/dotfiles/ctags $HOME/.ctags
    echo Create ctags symlink
else
    echo .ctags already exist
fi

if [ ! -e ~/.ackrc ]; then
    ln -s $HOME/workspace/dotfiles/ackrc $HOME/.ackrc
    echo Create ackrc symlink
else
    echo .ackrc already exist
fi

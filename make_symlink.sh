DOTFILES=$HOME/workspace/dotfiles

TAR=$HOME/.ctags
if [ ! -e $TAR ]; then
    ln -s $DOTFILES/ctags $TAR
    echo Create exuberant-ctags symlink
else
    echo .ctags already exist
fi

TAR=$HOME/.ctags.d/default.ctags
if [ ! -e $TAR ]; then
    mkdir -p $(dirname $TAR)
    ln -s $DOTFILES/ctags $TAR
    echo Create universal-ctags symlink
else
    echo default.ctags already exist
fi

TAR=$HOME/.ackrc
if [ ! -e $TAR ]; then
    ln -s $DOTFILES/ackrc $TAR
    echo Create ackrc symlink
else
    echo .ackrc already exist
fi

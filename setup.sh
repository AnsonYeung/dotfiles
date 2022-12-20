#!/bin/zsh

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
SCRIPT_DIR=$(realpath "$(dirname $0)")
FILES=$(cat $SCRIPT_DIR/file_list.txt)

if [ ! -f ~/.gdbinit ]; then
    curl -fsSLo ~/.gdbinit-gef.py http://gef.blah.cat/py
    echo source ~/.gdbinit-gef.py >> ~/.gdbinit
fi

gitdir_add() {
    if [ ! -d $1 ]; then
        git clone --filter=blob:none $2 $1
    fi
}

source $SCRIPT_DIR/gitdir_list.sh

for i in ${(f)FILES}; do
    mkdir -p $(dirname ~/$i)
    if [ -e ~/$i ]; then
        mv ~/$i ~/$i.old
    fi
    ln $SCRIPT_DIR/$i ~/$i -s
done

if [ -f ~/.zprofile ]; then
    mv ~/.zprofile ~/.zprofile.old
fi

ln .profile ~/.zprofile -s

exec zsh -l

#!/bin/bash

FILES=$(cat fileList.txt)
for i in $FILES; do
    mkdir -p `dirname ~/$i`
    ln $PWD/$i ~/$i "$@"
done
ln .profile ~/.zprofile "$@"
ln .logout ~/.zlogout "$@"
ln .gdbinit.gef ~/.gdbinit "$@"
if [ ! -d ~/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi

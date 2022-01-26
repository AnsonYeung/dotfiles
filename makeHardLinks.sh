#!/bin/bash

FILES=$(cat fileList.txt)
for i in $FILES; do
    mkdir -p `dirname ~/$i`
    ln $PWD/$i ~/$i "$@"
done
ln .profile ~/.zprofile "$@"
ln .gdbinit.gef ~/.gdbinit "$@"
#if [ ! -d ~/powerlevel10k ]; then
#    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
#fi
if [ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi


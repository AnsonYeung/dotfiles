#!/bin/bash

FILES=$(cat fileList.txt)
for i in $FILES; do
    mkdir -p `dirname ~/$i`
    ln $PWD/$i ~/$i "$@"
done

ln .profile ~/.zprofile "$@"
ln .gdbinit.gef ~/.gdbinit "$@"

if [ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom} ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/jeffreytse/zsh-vi-mode {ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

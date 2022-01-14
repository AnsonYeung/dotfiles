#!/bin/bash

FILES=$(cat fileList.txt)
mkdir -p ~/.config/nvim/UltiSnips
for i in $FILES; do
    ln $PWD/$i ~/$i
done
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

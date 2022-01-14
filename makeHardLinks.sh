#!/bin/bash

FILES=$(cat fileList.txt)
mkdir -p ~/.config/nvim/UltiSnips
for i in $FILES; do
    ln $PWD/$i ~/$i
done

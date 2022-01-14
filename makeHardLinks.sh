#!/bin/bash

FILES=$(cat fileList.txt)
for i in $FILES; do
    ln $i ~/$i
done

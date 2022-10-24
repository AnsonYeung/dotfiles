#!/bin/zsh
source $DOTFILES_DIR/autoupdatelist.sh
for plugpath url in ${(kv)autoupdatelist}; do
    silent_background sh -c "git -C $plugpath pull >> ~/.dotfiles.log 2>&1"
done

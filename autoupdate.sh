#!/bin/zsh
source $DOTFILES_DIR/autoupdatelist.sh
for plugpath url in ${(kv)autoupdatelist}; do
    # silent_background sh -c "git -C $plugpath pull --depth=1 2>&1 | tee -a ~/.dotfiles.log"
    silent_background sh -c "git -C $plugpath pull --depth=1 >> ~/.dotfiles.log 2>&1"
done

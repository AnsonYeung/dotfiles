#!/bin/zsh
gitdir_add() {
    silent_background sh -c "git -C $1 pull -q"
}
source $DOTFILES_DIR/gitdir_list.sh

#!/bin/zsh

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
SCRIPT_DIR=$(realpath "$(dirname $0)")
FILES=$(cat $SCRIPT_DIR/fileList.txt)

if [ ! -f ~/.gdbinit ]; then
    curl -fsSLo ~/.gdbinit-gef.py http://gef.blah.cat/py
    echo source ~/.gdbinit-gef.py >> ~/.gdbinit
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d ~/.oh-my-zsh ]; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh ~/.oh-my-zsh
fi

source $SCRIPT_DIR/autoupdatelist.sh
for plugpath url in ${(kv)autoupdatelist}; do
    if [ ! -d $plugpath ]; then
        git clone --depth=1 $url $plugpath
    fi
done

for i in ${(f)FILES}; do
    mkdir -p $(dirname ~/$i)
    ln $SCRIPT_DIR/$i ~/$i -s "$@"
done

ln .profile ~/.zprofile -s "$@"

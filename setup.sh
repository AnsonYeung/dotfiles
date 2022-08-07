#!/bin/zsh

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
SCRIPT_DIR=$(realpath "$(dirname $0)")
FILES=$(cat $SCRIPT_DIR/fileList.txt)

source $SCRIPT_DIR/autoupdatelist.sh
for plugpath url in ${(kv)autoupdatelist}; do
    if [ ! -d $plugpath ]; then
        git clone $url $plugpath
    fi
done

for i in ${(f)FILES}; do
    mkdir -p $(dirname ~/$i)
    ln $SCRIPT_DIR/$i ~/$i -s "$@"
done

ln .profile ~/.zprofile -s "$@"

if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

if [ ! -f ~/.gdbinit ]; then
    curl -fsSLo ~/.gdbinit-gef.py http://gef.blah.cat/py
    echo source ~/.gdbinit-gef.py >> ~/.gdbinit
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

#!/bin/bash

# oh my zsh will overwrite files on install
if [ ! -d ${ZSH:-$HOME/.oh-my-zsh} ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

ensure_install_ohmyzsh_custom() {
    if [ ! -d $ZSH_CUSTOM/$1 ]; then
        git clone $2 $ZSH_CUSTOM/$1
    fi
}

ensure_install_ohmyzsh_custom themes/powerlevel10k https://github.com/romkatv/powerlevel10k.git
ensure_install_ohmyzsh_custom plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
ensure_install_ohmyzsh_custom plugins/zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode.git
ensure_install_ohmyzsh_custom plugins/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
ensure_install_ohmyzsh_custom plugins/autoupdate https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git

SCRIPT_DIR=$(realpath "$(dirname $0)")
FILES=$(cat $SCRIPT_DIR/fileList.txt)

for i in $FILES; do
    mkdir -p $(dirname ~/$i)
    ln $SCRIPT_DIR/$i ~/$i "$@"
done

ln .profile ~/.zprofile "$@"

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

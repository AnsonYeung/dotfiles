#!/bin/zsh
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

gitdir_add ${DOTFILES_PATH:-$HOME/github/dotfiles} NULL
gitdir_add $HOME/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm
gitdir_add ${ZSH:-$HOME/.oh-my-zsh} https://github.com/ohmyzsh/ohmyzsh.git
gitdir_add $ZSH_CUSTOM/themes/powerlevel10k https://github.com/romkatv/powerlevel10k.git
gitdir_add $ZSH_CUSTOM/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
gitdir_add $ZSH_CUSTOM/plugins/zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode.git
gitdir_add $ZSH_CUSTOM/plugins/zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git

#!/bin/zsh
declare -A autoupdatelist
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
autoupdatelist[${DOTFILES_PATH:-$HOME/github/dotfiles}]="NULL"
autoupdatelist[${ZSH:-$HOME/.oh-my-zsh}]="https://github.com/ohmyzsh/ohmyzsh.git"
autoupdatelist[$ZSH_CUSTOM/themes/powerlevel10k]="https://github.com/romkatv/powerlevel10k.git"
autoupdatelist[$ZSH_CUSTOM/plugins/zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
autoupdatelist[$ZSH_CUSTOM/plugins/zsh-vi-mode]="https://github.com/jeffreytse/zsh-vi-mode.git"
autoupdatelist[$ZSH_CUSTOM/plugins/zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"

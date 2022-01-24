# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -aCF'

export PATH="$HOME/.r2env/bin:$PATH"
export CP="~/competitive-programming"
export EDITOR="nvim"
# wsl x server, disable this line if needed
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0

alias vim="nvim"
alias gef="gdb -x ~/.gdbinit.gef"
alias dis="objdump --demangle -M intel"
alias venv="source .venv/bin/activate"
if [ -f "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi

# https://superuser.com/questions/1228411/silent-background-jobs-in-zsh/1285272
# fetch in background
# Run the command given by "$@" in the background
silent_background() {
  if [[ -n $ZSH_VERSION ]]; then  # zsh:  https://superuser.com/a/1285272/365890
    setopt local_options no_notify no_monitor
    # We'd use &| to background and disown, but incompatible with bash, so:
    "$@" &
  elif [[ -n $BASH_VERSION ]]; then  # bash: https://stackoverflow.com/a/27340076/5353461
    { 2>&3 "$@"& } 3>&2 2>/dev/null
  else  # Unknownness - just background it
    "$@" &
  fi
  disown &>/dev/null  # Close STD{OUT,ERR} to prevent whine if job has already completed
}
silent_background git -C ~/github/dotfiles fetch

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
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.r2env/bin:$PATH"
export CP="$HOME/competitive-programming"
export EDITOR="nvim"
export LESS="-F -R $LESS"

if [ ! -z "$WSLENV" ]; then
    # export DISPLAY=$(/mnt/c/Windows/System32/ipconfig.exe | sed -n '/WSL/,+4p' | head -n 5 | tail -n 1 | sed -s "s/.*: //" | sed -s "s/\r//"):0
    export DISPLAY=$(/mnt/c/Windows/System32/ipconfig.exe | sed -n '/WSL/,+4p' | tail -n 1 | sed -s "s/.*: //" | sed -s "s/\r//"):0
fi

if [ -f "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi

if [ ! -z "$SSH_AGENT_PID" ] ; then
    DONT_KILL_SSH_AGENT=1
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

if [[ -n $ZSH_VERSION ]]; then
    DOTFILES_DIR=~/github/dotfiles
    source $DOTFILES_DIR/autoupdate.sh
fi

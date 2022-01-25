# delete ssh-agent on logout
if [ ! -z "$SSH_AGENT_PID" ] && [ -z "$DONT_KILL_SSH_AGENT" ]; then
    kill $SSH_AGENT_PID
fi
# silent background implemenation is in .zprofile, we're safe to call it
silent_background sh -c "{ git -C $DOTFILES_DIR add -A; git -C $DOTFILES_DIR commit -m \"auto commit\";  git -C $DOTFILES_DIR push; } >> ~/.dotfiles.log 2>&1"

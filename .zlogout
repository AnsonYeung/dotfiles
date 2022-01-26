# delete ssh-agent on logout
if [ ! -z "$SSH_AGENT_PID" ] && [ -z "$DONT_KILL_SSH_AGENT" ]; then
    kill $SSH_AGENT_PID
fi
# check dotfiles on logout
echo checking dotfiles
if [ -n "$(git -C $DOTFILES_DIR status -s)" ]; then
    echo dotfiles dirty
    { git -C $DOTFILES_DIR add -A; git -C $DOTFILES_DIR commit -m "auto commit";  git -C $DOTFILES_DIR push; } >> ~/.dotfiles.log 2>&1
fi
echo logout

# delete ssh-agent on logout
if [ ! -z "$SSH_AGENT_PID" ] && [ -z "$DONT_KILL_SSH_AGENT" ]; then
    kill $SSH_AGENT_PID
fi
# check dotfiles on logout
echo checking dotfiles
{ git -C $DOTFILES_DIR add -A; git -C $DOTFILES_DIR commit -m "auto commit";  git -C $DOTFILES_DIR push; } >> ~/.dotfiles.log 2>&1
echo logout

# delete ssh-agent on logout
# not killing agent other than wsl or termux
if [ ! -z "$SSH_AGENT_PID" ] && [ ! -z "$WSLENV" -o ! -z "$TERMUX_VERSION" ]; then
    kill $SSH_AGENT_PID
fi

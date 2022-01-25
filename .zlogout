# delete ssh-agent on logout
if [ ! -z "$SSH_AGENT_PID" ] && [ -z "$DONT_KILL_SSH_AGENT" ]; then
    kill $SSH_AGENT_PID
fi

# delete ssh-agent on logout
if [ ! -z "$SSH_AGENT_PID" ]; then
    kill $SSH_AGENT_PID
fi

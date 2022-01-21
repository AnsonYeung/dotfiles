# delete ssh-agent on logout, so won't leave tons of ssh-agent lying in memory.
if [ ! -z "$SSH_AGENT_PID" ]; then
    kill $SSH_AGENT_PID
fi

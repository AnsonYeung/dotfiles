# delete all ssh-agent keys on logout, so won't leave tons of ssh-agent lying in memory.
ssh-add -D

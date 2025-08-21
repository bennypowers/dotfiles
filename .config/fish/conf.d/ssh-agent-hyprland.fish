# Check if a Hyprland session is active
if set -q HYPRLAND_INSTANCE_SIGNATURE
    # Load SSH agent variables from file
    if test -f ~/.ssh/agent.env
        source ~/.ssh/agent.env
    end

    # If the agent is not running, but the file exists, it might be a stale PID.
    # In that case, kill it and restart the agent on the next Hyprland session.
    if not test -n "$SSH_AGENT_PID"
        if test -f ~/.ssh/agent.env
            rm ~/.ssh/agent.env
        end
    end
end

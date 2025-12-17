function sudo --description "Wrapper for sudo with OSC 3008 context support"
    # Check if we're in a kitty terminal that supports OSC 3008
    if test "$TERM" = "xterm-kitty"
        # Generate a unique context ID for this sudo session
        set context_id "sudo-"(random)

        # Send OSC 3008 start sequence for elevated context (official format)
        printf '\033]3008;start=%s;type=elevate\007' $context_id

        # Execute the actual sudo command
        command sudo $argv
        set sudo_exit_code $status

        # Send OSC 3008 end sequence (official format)
        printf '\033]3008;end=%s\007' $context_id

        # Return the original sudo exit code
        return $sudo_exit_code
    else
        # Not in kitty, just run sudo normally
        command sudo $argv
    end
end

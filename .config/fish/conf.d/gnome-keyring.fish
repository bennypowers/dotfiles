# In ~/.config/fish/config.fish (or handled via uwsm env)
if set -q GNOME_KEYRING_CONTROL
    set -gx SSH_AUTH_SOCK "$GNOME_KEYRING_CONTROL/ssh"
end

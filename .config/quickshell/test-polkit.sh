#!/bin/bash

# Test script for polkit authentication
echo "Testing polkit authentication system..."

# Stop current hyprpolkitagent
echo "Stopping current polkit agent..."
systemctl --user stop hyprpolkitagent

# Wait a moment
sleep 2

# Try a polkit action that should trigger authentication
echo "Triggering polkit authentication..."
systemctl status NetworkManager >/dev/null 2>&1 || echo "Command completed"

# Restart hyprpolkitagent
echo "Restarting original polkit agent..."
systemctl --user start hyprpolkitagent

echo "Test complete."
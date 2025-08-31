#!/bin/bash

# Get user info from AccountsService and extract key fields
USER_ID=$(id -u)
OUTPUT=$(dbus-send --system --print-reply --dest=org.freedesktop.Accounts \
    "/org/freedesktop/Accounts/User${USER_ID}" \
    org.freedesktop.DBus.Properties.GetAll \
    string:org.freedesktop.Accounts.User 2>/dev/null)

# Extract IconFile
ICON_FILE=$(echo "$OUTPUT" | grep "IconFile" -A1 | tail -1 | sed 's/.*string "\([^"]*\)".*/\1/')

# Extract RealName  
REAL_NAME=$(echo "$OUTPUT" | grep "RealName" -A1 | tail -1 | sed 's/.*string "\([^"]*\)".*/\1/')

# Extract Email
EMAIL=$(echo "$OUTPUT" | grep "Email" -A1 | tail -1 | sed 's/.*string "\([^"]*\)".*/\1/')

# Output in simple format
echo "ICON_FILE=$ICON_FILE"
echo "REAL_NAME=$REAL_NAME"
echo "EMAIL=$EMAIL"
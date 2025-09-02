#!/bin/bash

# Independent virt-viewer launcher script
# This script runs completely separate from quickshell

VM_NAME="$1"
WORKSPACE="$2"
START_DELAY="$3"
STARTUP_CHECK_DELAY="$4"

# Default values if not provided
VM_NAME="${VM_NAME:-silverblue}"
WORKSPACE="${WORKSPACE:-10}"
START_DELAY="${START_DELAY:-2}"
STARTUP_CHECK_DELAY="${STARTUP_CHECK_DELAY:-1}"

# Switch to workspace
hyprctl dispatch workspace "$WORKSPACE"

# Wait for VM to be ready
sleep "$START_DELAY"

# Wait until VM is running
until virsh domstate "$VM_NAME" | grep -q running; do
    sleep "$STARTUP_CHECK_DELAY"
done

# Launch virt-viewer
exec virt-viewer --attach "$VM_NAME"
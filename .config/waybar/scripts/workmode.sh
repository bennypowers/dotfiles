#!/bin/bash

VM_NAME="silverblue"

get_vm_state() {
  virsh domstate "$VM_NAME" 2>/dev/null
}

case "$1" in
  toggle)
    STATE=$(get_vm_state)
    if [[ "$STATE" == "running" ]]; then
      virsh dompm-suspend "$VM_NAME" disk
    else
      virsh start "$VM_NAME"
    fi
    ;;
  status)
    STATE=$(get_vm_state)
    if [[ "$STATE" == "running" ]]; then
      echo '{"text":"󰍹", "tooltip":"Work Mode: VM is running (click to suspend)"}'
    else
      echo '{"text":"󰏤", "tooltip":"Work Mode: VM is suspended (click to start/resume)"}'
    fi
    ;;
  *)
    ;;
esac

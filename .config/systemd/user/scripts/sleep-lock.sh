#!/bin/bash
# Lock screen on sleep, restore monitors on wakeup via logind PrepareForSleep signal
gdbus monitor --system \
    --dest org.freedesktop.login1 \
    --object-path /org/freedesktop/login1 \
  | while IFS= read -r line; do
      if echo "$line" | grep -q "PrepareForSleep (true,)"; then
          qs -c noctalia-shell ipc call lockScreen lock
          sleep 1
      elif echo "$line" | grep -q "PrepareForSleep (false,)"; then
          niri msg action power-on-monitors
      fi
    done

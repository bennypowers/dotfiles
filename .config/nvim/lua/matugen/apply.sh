#!/usr/bin/env bash
set -euo pipefail

pkill -SIGUSR1 nvim >/dev/null 2>&1 || true

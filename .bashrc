if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

if [ -f /etc/gentoo-release ]; then
  export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh

  if [[ "$(tty)" == "/dev/tty1" ]]; then
          dbus-run-session sway
  elif [ -x /bin/fish ]; then
          SHELL=/bin/fish exec fish
  fi
else
  # Put your fun stuff here.
  source ~/.config/bashrc
  . "$HOME/.cargo/env"

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  eval "$(starship init bash)"
fi

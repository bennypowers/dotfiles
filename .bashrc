# We have this against messing with Portage files.
# Bonus: now you can `npm install -g` without root.
# According to
# https://wiki.g.o/wiki/Node.js#npm
# https://stackoverflow.com/a/63026107/1879101
# https://www.reddit.com/r/Gentoo/comments/ydzkml/nodejs_is_it_ok_to_install_global_packages/
export NPM_CONFIG_PREFIX=$HOME/.local/
export PATH="/home/$USER/go/bin:/home/$USER/.local/bin:$NPM_CONFIG_PREFIX/bin:$PATH"
export QT_QPA_PLATFORMTHEME=qt6ct
export XDG_DATA_DIRS="$HOME/.var/app/com.valvesoftware.Steam/data/icons:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"

if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

if [ -f /etc/gentoo-release ]; then
  export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
  if [[ "$(tty)" == "/dev/tty1" ]] && uwsm check may-start; then
          exec uwsm start default
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


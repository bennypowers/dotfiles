fish_add_path $HOME/.rbenv/bin
fish_add_path /usr/local/opt/openssl@1.1/bin
fish_add_path /usr/local/opt/gettext/bin
fish_add_path /usr/local/opt/python/bin
fish_add_path ~/.yarn/bin
fish_add_path ~/.opencode/bin

# unicode
set -x LANG en_US.UTF-8

set -x SHELL /usr/bin/fish
set -x GIT_EDITOR nvim
set -x QT_QPA_PLATFORMTHEME qt5ct

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx PAGER less

set -gx NPM_CONFIG_PREFIX $HOME/.local/

set -x PATH $PATH ~/.ghcup/bin
set -x PATH ~/.config/go/bin $PATH
set -x PATH ~/.cabal/bin $PATH
set -x PATH ~/.cargo/bin $PATH
set -x PATH ~/.local/bin $PATH []
set -x PATH ~/bin $PATH []
set -x PATH /usr/local/opt/python/bin/ $PATH
set -x PATH /usr/local/opt/gnu-sed/libexec/gnubin $PATH
set -x PATH $DENO_INSTALL/bin $PATH
set -gx PATH $NPM_CONFIG_PREFIX/bin $PATH

set -x NODE_ENV
set -x NODE_OPTIONS --max_old_space_size=4096

set -gx LG_CONFIG_FILE ~/.config/lazygit/config.yml
set -gx GOPATH ~/.config/go
set -gx DENO_INSTALL ~/.deno
set -gx QMK_HOME ~/Projects/qmk_firmware
set -gx WIREIT_LOGGER quiet

set fish_key_bindings fish_vi_key_bindings

if type -q highlight
  set hilite (which highlight)
end

set fish_greeting ''

bind --preset -M insert \ce edit_command_buffer
bind --preset -M visual \ce edit_command_buffer
bind --preset -M insert \cv edit_command_buffer
bind --preset -M visual \cv edit_command_buffer
bind --preset \ce edit_command_buffer
bind --preset \cv edit_command_buffer
bind \ce edit_command_buffer
bind \cv edit_command_buffer

# aliases
alias c="clear; and source ~/.config/fish/config.fish; and colorscript --random"
alias g="git"
alias vim="nvim"
alias rub0="run0 --background=''"
alias vim-update="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias lg="lazygit"
alias lgc="lazygit -g ~/.cfg -w ~ -ucf $HOME/.config/lazygit/dotfiles.yml,$HOME/.config/lazygit/config.yml"
alias meld="flatpak run org.gnome.Meld"
alias ssk="kitten ssh"
alias pbcopy="xsel --input --clipboard"
alias pbpaste="xsel --output --clipboard"
alias makearm64="make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-"
alias codium="flatpak run com.vscodium.codium"

if status is-interactive
  if type -q rbenv
    source (rbenv init -|psub)
  end

  if type -q zoxide
    zoxide init fish | source
  end

  if type -q starship
    starship init fish | source
  end

  if type -q glab
    glab completion -s fish | source
  end

  function nvm_use_on_dir --on-variable PWD
    if test -e ./.nvmrc
      nvm -s use
    else if type -q node
      nvm -s use system
    end
  end

  nvm_use_on_dir
end

# eye candy
function fish_greeting
  if status is-interactive
    colorscript --random
  end
end

# pnpm
set -gx PNPM_HOME "/var/home/bennyp/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH


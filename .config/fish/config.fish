set -g fish_user_paths $HOME/.rbenv/bin $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/python/bin" $fish_user_paths
set -g fish_user_paths "~/.yarn/bin" $fish_user_paths

# unicode
set -x LANG en_US.UTF-8

set -x SHELL /usr/bin/fish
set -x GIT_EDITOR nvim

set -gx VISUAL nvim
set -gx EDITOR nvim

# set -x LESSOPEN "| $hilite %s --out-format xterm256 --quiet --force "
# set -x LESS " -R"

set -x PATH $PATH ~/.ghcup/bin
set -x PATH ~/go/bin $PATH
set -x PATH ~/.cabal/bin $PATH
set -x PATH ~/.cargo/bin $PATH
set -x PATH ~/.local/bin $PATH []
set -x PATH /usr/local/opt/python/bin/ $PATH
set -x PATH /usr/local/opt/gnu-sed/libexec/gnubin $PATH
set -x PATH $DENO_INSTALL/bin $PATH

set -x NODE_ENV
set -x NODE_OPTIONS --max_old_space_size=4096

set -gx LG_CONFIG_FILE ~/.config/lazygit/config.yml
set -gx GOPATH ~/.config/go
set -gx DENO_INSTALL ~/.deno
set -gx QMK_HOME ~/Projects/qmk_firmware
set -gx WIREIT_LOGGER quiet

set fish_key_bindings fish_vi_key_bindings
set hilite (which highlight)

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
alias c="clear; and omf reload"
alias g="git"
alias nr="npm run"
alias run="npm run"
alias rn="npm run"
alias realvim="vim"
alias oldvim="vim"
alias bramvim="vim"
# alias vim="env TERM=wezterm nvim"
alias vim="nvim"
alias vim-update="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias lg="lazygit"
alias lgc="lazygit -g ~/.cfg -w ~"
alias meld="flatpak run org.gnome.Meld"

switch (uname)
    case Linux
      alias wezterm="flatpak run org.wezfurlong.wezterm"
      set -gx MOZ_ENABLE_WAYLAND 1
end


if status is-interactive
  source (rbenv init -|psub)
  starship init fish | source
end

# eye candy
function fish_greeting
  if status is-interactive
    colorscript random 2> /dev/null
  end
end

zoxide init fish | source

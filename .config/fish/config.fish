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
set -gx PAGER less

# set -x LESSOPEN "| $hilite %s --out-format xterm256 --quiet --force "
# set -x LESS " -R"

# set -gx LESS_TERMCAP_mb "$(tput bold; tput setaf 10)" # green
# set -gx LESS_TERMCAP_md "$(tput bold; tput setaf 14)" # cyan
# set -gx LESS_TERMCAP_me "$(tput sgr0)"
# set -gx LESS_TERMCAP_so "$(tput bold; tput setaf 11; tput setab 12)" # yellow on blue
# set -gx LESS_TERMCAP_se "$(tput rmso; tput sgr0)"
# set -gx LESS_TERMCAP_us "$(tput smul; tput bold; tput setaf 15)" # white
# set -gx LESS_TERMCAP_ue "$(tput rmul; tput sgr0)"
# set -gx LESS_TERMCAP_mr "$(tput rev)"
# set -gx LESS_TERMCAP_mh "$(tput dim)"
# set -gx LESS_TERMCAP_ZN "$(tput ssubm)"
# set -gx LESS_TERMCAP_ZV "$(tput rsubm)"
# set -gx LESS_TERMCAP_ZO "$(tput ssupm)"
# set -gx LESS_TERMCAP_ZW "$(tput rsupm)"
# set -gx GROFF_NO_SGR 1

set -x PATH $PATH ~/.ghcup/bin
set -x PATH ~/.config/go/bin $PATH
set -x PATH ~/.cabal/bin $PATH
set -x PATH ~/.cargo/bin $PATH
set -x PATH ~/.local/bin $PATH []
set -x PATH ~/bin $PATH []
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
alias c="clear; and source ~/.config/fish/config.fish"
alias g="git"
alias v="nvim"
alias vi="nvim"
alias run="npm run"
alias vim="nvim"
alias rub0="run0 --background=''"
alias vim-update="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias lg="lazygit"
alias lgc="lazygit -g ~/.cfg -w ~"
alias meld="flatpak run org.gnome.Meld"
alias ssk="kitten ssh"
alias pbcopy="xsel --input --clipboard"
alias pbpaste="xsel --output --clipboard"
alias makearm64="make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-"

switch (uname)
    case Linux
      alias wezterm="flatpak run org.wezfurlong.wezterm"
end


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
  if status is-interactive; and type -q colorscript
    colorscript --random
  end
end

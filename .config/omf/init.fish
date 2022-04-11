status --is-interactive; and source (rbenv init -|psub)

set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/python/bin" $fish_user_paths
set -g fish_user_paths "~/.yarn/bin" $fish_user_paths

# My Additions

# aliases
alias g="git"
alias nr="npm run"
alias run="nr"
alias rn="nr"
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias realvim="vim"
alias oldvim="realvim"
alias bramvim="realvim"
alias vim="env TERM=wezterm nvim"
alias vim-update="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"

# unicode
set -x LANG en_US.UTF-8
set -x LC_COLLATE en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8
set -x LC_MESSAGES en_US.UTF-8
set -x LC_MONETARY en_US.UTF-8
set -x LC_NUMERIC en_US.UTF-8
set -x LC_TIME en_US.UTF-8
set -x LC_ALL en_US.UTF-8

set fish_key_bindings fish_vi_key_bindings
set hilite (which highlight)

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx LG_CONFIG_FILE "/Users/bennyp/.config/lazygit/config.yml"

set -x SHELL fish
set -x EDITOR nvim
set -x GIT_EDITOR nvim

set -x LESSOPEN "| $hilite %s --out-format xterm256 --quiet --force "
set -x LESS " -R"

set -x PATH $PATH ~/.ghcup/bin
set -x PATH $HOME"/.cabal/bin" $PATH
set -x PATH $HOME/.local/bin $PATH []
set -x PATH /usr/local/opt/python/bin/ $PATH
set -x PATH /usr/local/opt/gnu-sed/libexec/gnubin $PATH

set -x NODE_ENV
set -x NODE_OPTIONS --max_old_space_size=4096

set fish_greeting ''

bind --preset -M insert \ce edit_command_buffer
bind --preset -M visual \ce edit_command_buffer
bind --preset -M insert \cv edit_command_buffer
bind --preset -M visual \cv edit_command_buffer
bind --preset \ce edit_command_buffer
bind --preset \cv edit_command_buffer
bind \ce edit_command_buffer
bind \cv edit_command_buffer

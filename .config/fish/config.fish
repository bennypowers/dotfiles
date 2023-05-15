set -g fish_user_paths $HOME/.rbenv/bin $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/python/bin" $fish_user_paths
set -g fish_user_paths "~/.yarn/bin" $fish_user_paths
set -g fish_user_paths "~/miniconda3/bin" $fish_user_paths

if status is-interactive
  source (rbenv init -|psub)
  starship init fish | source
end

# eye candy
function fish_greeting
  colorscript random 2> /dev/null
end

# override btf for to use terminal colors
function __bobthefish_colors -S -a color_scheme -d 'Define colors used by bobthefish'
  set -x color_initial_segment_exit     brwhite red  --bold
  set -x color_initial_segment_private  brwhite white
  set -x color_initial_segment_su       brwhite purple --bold
  set -x color_initial_segment_jobs     brwhite brblack --bold

  set -x color_path                     blue brwhite
  set -x color_path_basename            blue brwhite --bold
  set -x color_path_nowrite             blue red
  set -x color_path_nowrite_basename    blue red --bold

  set -x color_repo                     green black
  set -x color_repo_work_tree           blue brwhite --bold
  set -x color_repo_dirty               red black
  set -x color_repo_staged              bryellow black

  set -x color_vi_mode_default          black bryellow --bold
  set -x color_vi_mode_insert           green black --bold
  set -x color_vi_mode_visual           yellow black --bold

  set -x color_vagrant                  brmagenta black --bold
  set -x color_k8s                      magenta black --bold
  set -x color_aws_vault                brblack bryellow --bold
  set -x color_aws_vault_expired        brblack red --bold
  set -x color_username                 blue cyan --bold
  set -x color_hostname                 blue cyan
  set -x color_rvm                      red black --bold
  set -x color_node                     green black --bold
  set -x color_virtualfish              brblack black --bold
  set -x color_virtualgo                cyan black --bold
  set -x color_desk                     brblack black --bold
  set -x color_nix                      cyan black --bold
end

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
set -gx LG_CONFIG_FILE ~/.config/lazygit/config.yml
set -gx QMK_HOME ~/Projects/qmk_firmware

set -x SHELL /usr/bin/fish
set -x EDITOR nvim
set -x GIT_EDITOR nvim

set -x LESSOPEN "| $hilite %s --out-format xterm256 --quiet --force "
set -x LESS " -R"

set -x DENO_INSTALL ~/.deno
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
alias wezterm="flatpak run org.wezfurlong.wezterm"
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


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -e ~/miniconda3/bin/conda
  eval ~/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<


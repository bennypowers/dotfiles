set -g fish_user_paths $HOME/.rbenv/bin $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl@1.1/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/python/bin" $fish_user_paths
set -g fish_user_paths "~/.yarn/bin" $fish_user_paths

status --is-interactive; and source (rbenv init -|psub)

# override btf for github dark theme
function __bobthefish_colors -S -a color_scheme -d 'Define colors used by bobthefish'
  # GitHub Dark
  set -l cyan         39c5cf
  set -l green        3fb950
  set -l orange       ffa657
  set -l pink         bc8ccf
  set -l red          ff7b72
  set -l yellow       d29922
  set -l bg           0d1117
  set -l selection    163356
  set -l fg           4d5566
  set -l comment      8b949e
  set -l purple       bd93f9
  set -l current_line 44475a

  set -x color_initial_segment_exit     $fg $red  --bold
  set -x color_initial_segment_private  $fg $selection
  set -x color_initial_segment_su       $fg $purple --bold
  set -x color_initial_segment_jobs     $fg $comment --bold

  set -x color_path                     $selection $fg
  set -x color_path_basename            $selection $fg --bold
  set -x color_path_nowrite             $selection $red
  set -x color_path_nowrite_basename    $selection $red --bold

  set -x color_repo                     $green $bg
  set -x color_repo_work_tree           $selection $fg --bold
  set -x color_repo_dirty               $red $bg
  set -x color_repo_staged              $yellow $bg

  set -x color_vi_mode_default          $bg $yellow --bold
  set -x color_vi_mode_insert           $green $bg --bold
  set -x color_vi_mode_visual           $orange $bg --bold

  set -x color_vagrant                  $pink $bg --bold
  set -x color_k8s                      $purple $bg --bold
  set -x color_aws_vault                $comment $yellow --bold
  set -x color_aws_vault_expired        $comment $red --bold
  set -x color_username                 $selection $cyan --bold
  set -x color_hostname                 $selection $cyan
  set -x color_rvm                      $red $bg --bold
  set -x color_node                     $green $bg --bold
  set -x color_virtualfish              $comment $bg --bold
  set -x color_virtualgo                $cyan $bg --bold
  set -x color_desk                     $comment $bg --bold
  set -x color_nix                      $cyan $bg --bold
end

# My Additions

# aliases
alias g="git"
alias nr="npm run"
alias run="npm run"
alias rn="npm run"
alias realvim="vim"
alias oldvim="vim"
alias bramvim="vim"
alias vim="env TERM=wezterm nvim"
alias vim-update="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

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

set -x SHELL fish
set -x EDITOR nvim
set -x GIT_EDITOR nvim

set -x LESSOPEN "| $hilite %s --out-format xterm256 --quiet --force "
set -x LESS " -R"

set -x PATH $PATH ~/.ghcup/bin
set -x PATH ~/.cabal/bin $PATH
set -x PATH ~/.cargo/bin $PATH
set -x PATH ~/.local/bin $PATH []
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

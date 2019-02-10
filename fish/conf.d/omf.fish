# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish

# My Additions
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
set -x LESSOPEN "| $hilite %s --out-format xterm256 --quiet --force "
set -x LESS " -R"
set -x PATH $HOME"/.cabal/bin" $PATH
set -x SHELL fish
set -x EDITOR vim
set -x GIT_EDITOR vim

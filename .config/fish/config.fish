set -x LANG en_US.UTF-8

set -x SHELL /usr/bin/fish
set -x GIT_EDITOR nvim

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx PAGER less

set -gx LG_CONFIG_FILE ~/.config/lazygit/config.yml
set -gx GOPATH ~/.config/go
set -gx QMK_HOME ~/Projects/qmk_firmware
set -gx WIREIT_LOGGER quiet

fish_add_path /usr/lib/eselect-wine/bin

set -g fish_key_bindings fish_vi_key_bindings

# eye candy
function fish_greeting
    if status is-interactive
        colorscript --random
    end
end

bind --preset -M insert \ce edit_command_buffer
bind --preset -M visual \ce edit_command_buffer
bind --preset -M insert \cv edit_command_buffer
bind --preset -M visual \cv edit_command_buffer
bind --preset \ce edit_command_buffer
bind --preset \cv edit_command_buffer
bind \ce edit_command_buffer
bind \cv edit_command_buffer

if type -q highlight
    set hilite (which highlight)
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
end

# aliases
alias c="clear; and source ~/.config/fish/config.fish; and colorscript --random"
alias g="git"
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias lg="lazygit"
alias lgc="lazygit -g ~/.cfg -w ~ -ucf $HOME/.config/lazygit/dotfiles.yml,$HOME/.config/lazygit/config.yml"
alias meld="flatpak run org.gnome.Meld"
alias ssk="kitten ssh"
alias pbcopy="xsel --input --clipboard"
alias pbpaste="xsel --output --clipboard"
alias r="run0"
alias rb="run0 --background=''"


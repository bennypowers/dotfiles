git clone --bare https://github.com/bennypowers/dotfiles.git $HOME/.cfg

function pecho {
  echo -e "\e[1;34m$1\e[0m"
}

function config {
  /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

pecho "Checking out config files..."
config checkout

if [ $? = 0 ]; then
  pecho "Checked out config.";
else
  pecho "Backing up pre-existing dot files.";
  FILES=$(config checkout 2>&1 | egrep "\s+\." | awk {'print $1'})
  for file in $FILES; do
    pecho "Backing up $file"
    mkdir -p .config-backup/$(dirname $file)
    mv $file .config-backup/$file
  done
  pecho "Finished Backup";
fi;

pecho "Verifying checkout..."
config checkout

config config status.showUntrackedFiles no

pecho "Homebrew..."
brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

pecho "Fish Shell..."
fish --version || brew install fish

pecho "Installing Dependencies..."
brew install                 \
  reattach-to-user-namespace \
  thefuck                    \
  python                     \
  highlight


pip3 install powerline-status

pecho "Installing Vim Plugins..."
vim +PluginInstall +qall

pecho "Done!"

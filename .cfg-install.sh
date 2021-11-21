git clone --bare https://github.com/bennypowers/dotfiles.git $HOME/.cfg

function config {
  /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

echo "Checking out config files..."
config checkout

if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
  FILES=$(config checkout 2>&1 | egrep "\s+\." | awk {'print $1'})
  for file in $FILES; do
    echo "Backing up $file"
    mkdir -p .config-backup/$(dirname $file)
    mv $file .config-backup/$file
  done
  echo "Finished Backup"
fi;

echo "Verifying checkout..."
config checkout

echo "Install Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

config config status.showUntrackedFiles no

echo "Homebrew..."
brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Fish Shell..."
fish --version || brew install fish

echo "Installing Dependencies..."
brew install                 \
  reattach-to-user-namespace \
  thefuck                    \
  python                     \
  highlight


pip3 install powerline-status

echo "Installing Vim Plugins..."
vim +PluginInstall +qall

echo "Done!"

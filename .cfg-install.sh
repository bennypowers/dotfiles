echo "Cloning dotfiles repo..."
git clone --bare https://github.com/bennypowers/dotfiles.git $HOME/.cfg

function config {
  /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;

config checkout

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

echo "Done!"

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


brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fish --version || brew install fish

brew install reattach-to-user-namespace
brew install thefuck
brew install python
pip3 install powerline-status

if [ -d "$HOME/.cfg" ]; then
  set MY_CWD = `pwd`
  cd $HOME/.cfg
  git pull
  cd `echo $MY_CWD`
else
  git clone --bare https://github.com/bennypowers/dotfiles.git $HOME/.cfg
fi

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

config config status.showUntrackedFiles no

echo "Homebrew..."
brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Fish Shell..."
fish --version || brew install fish

echo "Installing Dependencies..."
brew install                 \
  reattach-to-user-namespace \
  thefuck                    \
  tmux                       \
  python                     \
  highlight                  \
  go

echo "Installing Powerline..."
pip3 install powerline-status

echo "Install nvim Packer..."
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "Installing Vim Plugins..."
rm -r ~/.config/nvim/plugin/packer_compiled.lua
nvim -u ~/.config/nvim/lua/plugins.lua --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Done!"

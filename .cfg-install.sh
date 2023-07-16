#!/bin/bash

function confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure?} [y/N]" response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

function get_or_update_dotfiles() {
  if [ -d "$HOME/.cfg" ]; then
    set MY_CWD = `pwd`;
    cd $HOME/.cfg;
    git pull;
    cd `echo $MY_CWD`;
  else
    git clone --bare https://github.com/bennypowers/dotfiles.git $HOME/.cfg;
  fi;
};

function config() {
  /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@;
};

function checkout_config() {
  echo "Checking out config files...";
  config checkout;

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
}

function install_deps() {
  if [[ "$OSTYPE" == "linux-gnu"* ]];
  then
    echo "Installing dependencies on Linux";
    echo "Fish Shell...";
    fish --version || sudo dnf install fish;
    echo "NodeJS...";
    node --version || sudo dnf install nodejs;

    echo "Installing Dependencies...";
    sudo dnf install             \
      gh                         \
      rust                       \
      ripgrep                    \
      lazygit                    \
      git-delta                  \
      rbenv                      \
      thefuck                    \
      highlight                  \
      go                         \
      && echo "Done!"

    echo "Node JS Global Packages...";
    npm i -g \
      eslint_d \
      nvm \
      && echo "Done!"
  elif [[ "$OSTYPE" == "darwin"* ]];
  then
    echo "Installing dependencies with Homebrew";
    echo "Homebrew...";
    brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";

    echo "Fish Shell...";
    fish --version || brew install fish;

    echo "Wezterm...";
    wezterm --version || brew install --cask wezterm;

    echo "Installing Dependencies...";
    brew install                 \
      gh                         \
      node                       \
      ripgrep                    \
      lazygit                    \
      git-delta                  \
      rbenv                      \
      thefuck                    \
      python                     \
      highlight                  \
      rust                       \
      go                         \
      && echo "Done!"

    echo "Node JS Global Packages...";
    npm i -g \
      eslint_d \
      nvm \
      && echo "Done!"
  fi;
};

function install_font() {
  FONT=$1
  ZIPFILE_NAME="${FONT}.zip"
  DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERDFONTS_LATEST_VERSION}/${ZIPFILE_NAME}"
  echo "Downloading $DOWNLOAD_URL"
  wget "$DOWNLOAD_URL"
  unzip -u "$ZIPFILE_NAME" -d "$FONTS_DIR" -x "*.txt/*" -x "*.md/*"
  rm "$ZIPFILE_NAME"
}

function install_nerd_fonts() {
  echo "Installing Nerd fonts";

  declare -a fonts=(
    AnonymousPro
    CascadiaCode
    FiraCode
    FiraMono
    Hack
    Iosevka
    LiberationMono
    Noto
    Overpass
    RobotoMono
    Terminus
    Ubuntu
    UbuntuMono
  );

  if  [[ "$OSTYPE" == "darwin"* ]]; then
    brew tap homebrew/cask-fonts;
    for FONT in "${fonts[@]}"; do
      brew install "font-$(sed --expression 's/\([A-Z]\)/-\L\1/g' --expression 's/^-//' <<< "$FONT")-nerd-font";
    done;
  else
    NERDFONTS_LATEST_VERSION="$(gh release list \
       --exclude-drafts \
       --exclude-pre-releases \
       --limit 1 \
       --repo ryanoasis/nerd-fonts \
       | grep Latest \
       | awk '{print substr($1, 2);}')"; # take the first word of the line and remove the first char

    FONTS_DIR="${HOME}/.local/share/fonts";

    if [[ ! -d "$FONTS_DIR" ]]; then
        mkdir -p "$FONTS_DIR"
    fi

    for FONT in "${fonts[@]}"; do
        confirm "Install $FONT?" && install_font "$FONT"
    done

    find "$FONTS_DIR" -name '*Windows Compatible*' -delete

    fc-cache -fv
  fi;
}

function set_fish_default_shell() {
  if  [[ "$OSTYPE" == "darwin"* ]]; then
    confirm "Edit /etc/shells to confirm '/usr/local/bin/fish' is listed?" && sudo nvim /etc/shells
    confirm "Set fish as default shell?" && chsh -s /usr/local/bin/fish
  else
    confirm "Edit /etc/shells to confirm '/usr/bin/fish' is listed?" && sudo nvim /etc/shells
    confirm "Set fish as default shell?" && chsh -s /usr/bin/fish
  fi;
}

function install_starship() {
  curl -sS https://starship.rs/install.sh | sh
}

function install_colorscripts() {
  # waiting on https://gitlab.com/dwt1/shell-color-scripts/-/merge_requests/34
  # git clone https://gitlab.com/dwt1/shell-color-scripts.git
  cd ~/Developer
  git clone https://gitlab.com/bennyp/shell-color-scripts.git
  cd shell-color-scripts
  sudo make install
  cp completions/colorscript.fish ~/.config/fish/completions/
  cd ~
}

get_or_update_dotfiles
checkout_config
confirm "Install dependencies?"        && install_deps
confirm "Install nerd fonts?"          && install_nerd_fonts
confirm "Install starship prompt?"     && install_starship
confirm "Install color scripts?"       && install_colorscripts
set_fish_default_shell
echo "Done!";

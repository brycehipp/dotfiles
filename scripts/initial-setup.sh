#! /bin/bash

has_brew_in_path() {
  if command -v brew &> /dev/null
  then
    return 0
  fi

  return 1
}

try_install_brew() {
  # Skip install if we found the `brew` command
  if has_brew_in_path
  then
    echo "Homebrew already exists in the path. Skipping."
    return 0
  fi

  # Make sure we want to install homebrew
  read -p "Install homebrew? (y/N) " BREW_INSTALL_YN
  case "$BREW_INSTALL_YN" in
    [nN]|[oO] )
      return 0;;
  esac

  # Allow for installing homebrew in the user dir
  read -p "Install homebrew under the user dir? (y/N) " BREW_USER_DIR_YN

  BREW_DIR="${HOME}/homebrew"

  case "$BREW_USER_DIR_YN" in
    [yY][eE][sS]|[yY] )
      if [[ -d "$BREW_DIR" ]]
      then
        echo "Can't install homebrew. Directory $BREW_DIR already exists."
      else
        echo "Installing homebrew in $BREW_DIR"
        mkdir $BREW_DIR && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $BREW_DIR
      fi
      ;;
    * )
      echo "Installing homebrew globally"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      ;;
  esac

  ./brew.sh
}

try_create_dev_folder() {
  DEV_DIR=$(gum input --cursor.foreground "#FF0" --prompt.foreground "#0FF" --prompt "What should be used as a dev folder? " --placeholder ~/dev)
  test -z "$DEV_DIR" && DEV_DIR="$HOME/dev" # default to ~/dev if nothing provided

  if [[ ! -d "$DEV_DIR" ]]
  then
    mkdir "$DEV_DIR"
    echo "Created $DEV_DIR"
  else
    echo "$DEV_DIR already exists. Skipping."
  fi
}

try_install_ohmyzsh() {
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

set_apple_defaults() {
  echo "[ApplePressAndHoldEnabled] Disable press-and-hold for keys in favor of key repeat."
  defaults write -g ApplePressAndHoldEnabled -bool false
}

clear
echo "Setting up computer..."

echo -e "\n## oh-my-zsh ##"
try_install_ohmyzsh

echo -e "\n## Homebrew ##"
try_install_brew

echo -e "\n## Folders ##"
try_create_dev_folder

echo -e "\n## Apple Defaults ##"
set_apple_defaults

./bootstrap.sh

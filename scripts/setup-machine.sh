#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}

source "$SCRIPT_DIR/ui.sh"

has_brew_in_path() {
  if command -v brew >/dev/null 2>&1
  then
    return 0
  fi

  return 1
}

prompt_yes_no() {
  local prompt="$1"
  local response

  read "response?${prompt}"

  case "$response" in
    [yY]|[yY][eE][sS])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

try_install_brew() {
  # Skip install if we found the `brew` command
  if has_brew_in_path
  then
    success "Homebrew already exists in the path. Skipping."
    return 0
  fi

  # Make sure we want to install homebrew
  if ! prompt_yes_no "Install homebrew? (y/N) "
  then
    info "Skipping Homebrew installation."
    return 0
  fi

  BREW_DIR="${HOME}/homebrew"

  # Allow for installing homebrew in the user dir
  if prompt_yes_no "Install homebrew under the user dir? (y/N) "
  then
    if [[ -d "$BREW_DIR" ]]
    then
      info "Skipping user-dir Homebrew install. Directory $BREW_DIR already exists."
      return 0
    else
      info "Installing homebrew in $BREW_DIR"
      mkdir -p "$BREW_DIR"
      curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_DIR"
    fi
  else
    info "Installing homebrew globally"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  "$SCRIPT_DIR/brew.sh"
}

try_create_dev_folder() {
  local dev_dir

  read "dev_dir?What should be used as a dev folder? [~/dev] "
  [[ -z "$dev_dir" ]] && dev_dir="$HOME/dev"
  [[ "$dev_dir" == '~/'* ]] && dev_dir="$HOME/${dev_dir#~/}"

  if [[ ! -d "$dev_dir" ]]
  then
    mkdir -p "$dev_dir"
    success "Created $dev_dir"
  else
    success "$dev_dir already exists. Skipping."
  fi
}

try_install_ohmyzsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]
  then
    success "oh-my-zsh is already installed. Skipping."
    return 0
  fi

  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

set_apple_defaults() {
  info "[ApplePressAndHoldEnabled] Disable press-and-hold for keys in favor of key repeat."
  defaults write -g ApplePressAndHoldEnabled -bool false
}

install_gitalias() {
  local dir=${XDG_CONFIG_HOME:-$HOME/.config}/gitalias
  local gitalias_path="$dir/gitalias.txt"

  mkdir -p "$dir"

  info "Downloading gitalias..."
  curl -fsSL https://raw.githubusercontent.com/GitAlias/gitalias/main/gitalias.txt -o "$gitalias_path"
  success "Downloaded gitalias"

  if git config --global --get-all include.path | grep -qxF "$gitalias_path"
  then
    info "gitalias already present in git include.path"
    return 0
  fi

  git config --global --add include.path "$gitalias_path"
  success "Added gitalias to git include.path"
}

clear
echo "Setting up computer..."

section "oh-my-zsh"
try_install_ohmyzsh

section "Homebrew"
try_install_brew

section "Folders"
try_create_dev_folder

section "Apple Defaults"
set_apple_defaults
success "Applied Apple defaults"

section "Gitalias"
install_gitalias
success "Installed gitalias"

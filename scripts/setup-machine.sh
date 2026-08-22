#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}

source "$SCRIPT_DIR/ui.sh"

activate_brew() {
  local brew_path

  if command -v brew >/dev/null 2>&1; then
    brew_path=$(command -v brew)
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    brew_path=/opt/homebrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_path=/usr/local/bin/brew
  else
    return 1
  fi

  eval "$("$brew_path" shellenv zsh)"
}

try_install_brew() {
  if activate_brew; then
    success "Homebrew already exists."
  else
    if ! read -q "response?Install Homebrew? (y/N) "; then
      echo
      info "Skipping Homebrew installation."
      return 0
    fi
    echo

    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if ! activate_brew; then
      fail "Homebrew installed, but brew could not be found."
    fi
  fi

  zsh "$SCRIPT_DIR/brew.sh"
}

try_create_dev_folder() {
  local dev_dir

  read "dev_dir?What should be used as a dev folder? [~/dev] "
  [[ -z "$dev_dir" ]] && dev_dir="$HOME/dev"
  [[ "$dev_dir" == '~/'* ]] && dev_dir="$HOME/${dev_dir#~/}"

  if [[ ! -d "$dev_dir" ]]; then
    mkdir -p "$dev_dir"
    success "Created $dev_dir"
  else
    success "$dev_dir already exists. Skipping."
  fi
}

try_install_ohmyzsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    success "oh-my-zsh is already installed. Skipping."
    return 0
  fi

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
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

  if git config --global --get-all include.path | grep -qxF "$gitalias_path"; then
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

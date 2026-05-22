#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}
BREWFILE_PATH="$SCRIPT_DIR/../Brewfile"

brew bundle install --file="$BREWFILE_PATH"

mkdir -p ~/.config
touch ~/.config/starship.toml

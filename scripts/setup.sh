#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}

"$SCRIPT_DIR/install-dotfiles.sh"
"$SCRIPT_DIR/setup-machine.sh"

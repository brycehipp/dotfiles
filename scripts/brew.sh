#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}
DOTFILES_ROOT="$SCRIPT_DIR/.."
PROFILES_FILE="$DOTFILES_ROOT/brew-profiles.local"

install_brewfile() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "Brewfile not found: $file" >&2
    return 1
  fi
  echo "brew bundle: $file"
  brew bundle install --no-upgrade --file="$file"
}

want_profile() {
  local name="$1"
  local line

  [[ -f "$PROFILES_FILE" ]] || return 1
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" == \#* || -z "$line" ]] && continue
    [[ "$line" == "$name" ]] && return 0
  done <"$PROFILES_FILE"
  return 1
}

install_agents=false
install_work=false

if (( $# == 0 )); then
  want_profile agents && install_agents=true
  want_profile work && install_work=true
else
  while (( $# > 0 )); do
    case "$1" in
      --main) ;;
      --agents) install_agents=true ;;
      --work) install_work=true ;;
      --all)
        install_agents=true
        install_work=true
        ;;
      *)
        echo "Usage: brew.sh [--main] [--agents] [--work] [--all]" >&2
        echo "Always installs Brewfile. With no args, also installs optional files listed in brew-profiles.local." >&2
        exit 1
        ;;
    esac
    shift
  done
fi

install_brewfile "$DOTFILES_ROOT/Brewfile"
$install_agents && install_brewfile "$DOTFILES_ROOT/Brewfile.agents"
$install_work && install_brewfile "$DOTFILES_ROOT/Brewfile.work"

#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_ROOT=${0:A:h:h}
TEST_HOME=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-doctor.XXXXXX")
trap 'rm -rf -- "$TEST_HOME"' EXIT

ln -s "$DOTFILES_ROOT" "$TEST_HOME/.dotfiles"
touch "$TEST_HOME/gitconfig"

if output=$(HOME="$TEST_HOME" GIT_CONFIG_GLOBAL="$TEST_HOME/gitconfig" zsh -c \
  'set -e; source "$HOME/.dotfiles/shell/functions.zsh"; df.doctor' 2>&1); then
  exit 1
fi
[[ "$output" == *"0/14 configured (0%)."* ]]
[[ "$output" == *"Run df.doctor --fix to apply fixes."* ]]

git config --file "$TEST_HOME/gitconfig" user.name "Doctor Test"
git config --file "$TEST_HOME/gitconfig" user.email "doctor@example.com"
output=$(HOME="$TEST_HOME" GIT_CONFIG_GLOBAL="$TEST_HOME/gitconfig" zsh -c \
  'set -e; source "$HOME/.dotfiles/shell/functions.zsh"; df.doctor --fix')
[[ "$output" == *"14/14 configured (100%)."* ]]

echo "Doctor smoke test passed."

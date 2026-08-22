#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_ROOT=${0:A:h:h}
TEST_HOME=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")
trap 'rm -rf -- "$TEST_HOME"' EXIT

ln -s "$DOTFILES_ROOT" "$TEST_HOME/.dotfiles"
git config --file "$TEST_HOME/gitconfig" user.name "Install Test"
git config --file "$TEST_HOME/gitconfig" user.email "install@example.com"

for run in 1 2; do
  env HOME="$TEST_HOME" GIT_CONFIG_GLOBAL="$TEST_HOME/gitconfig" \
    zsh "$DOTFILES_ROOT/scripts/install-dotfiles.sh" >/dev/null
done

local -A links=(
  .zshrc .zshrc
  .gitignore-global .gitignore-global
  .gitattributes-global .gitattributes-global
  AGENTS.md llm/AGENTS.md
  .config/starship.toml config/starship.toml
  .config/ghostty/config.ghostty config/ghostty/config.ghostty
  .config/zed/settings.json config/zed/settings.json
  .config/zed/keymap.json config/zed/keymap.json
)

local destination source
for destination source in ${(kv)links}; do
  [[ "$(readlink "$TEST_HOME/$destination")" == "$TEST_HOME/.dotfiles/$source" ]]
done

[[ "$(git config --file "$TEST_HOME/gitconfig" init.defaultBranch)" == main ]]
[[ "$(git config --file "$TEST_HOME/gitconfig" core.autocrlf)" == input ]]

echo "Install smoke test passed."

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
# use user's Applications dir for casks/apps
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

if command -v brew >/dev/null 2>&1; then
  local homebrew_dir="$(brew --prefix)"

  # fish-like autosuggestions
  [[ -f "$homebrew_dir/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$homebrew_dir/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

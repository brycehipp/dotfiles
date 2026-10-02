export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# predictive ghost-text autosuggestions (replaces zsh-autosuggestions)
if [[ -r "$HOME/.local/share/deja/init.zsh" ]]; then
  source "$HOME/.local/share/deja/init.zsh"
elif command -v deja >/dev/null 2>&1; then
  eval "$(deja init zsh)"
fi

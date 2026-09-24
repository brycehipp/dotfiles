# Always loaded (interactive and non-interactive). Agents/scripts often skip
# .zshrc, so PATH and env they need belong here. Keep this file small.

# Static brew env (no `brew shellenv` fork on every zsh).
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_PREFIX=/opt/homebrew
  elif [[ -x /usr/local/bin/brew ]]; then
    export HOMEBREW_PREFIX=/usr/local
  fi
  if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH:+:$PATH}"
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
  fi
fi

export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"

typeset -U path PATH
path=(
  "$PNPM_HOME/bin"
  "$HOME/.local/bin"
  "$BUN_INSTALL/bin"
  $path
)

# libpq is keg-only
[[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/opt/libpq/bin" ]] && \
  path=("$HOMEBREW_PREFIX/opt/libpq/bin" $path)

# vite-plus PATH only; vp() wrapper stays in .zshrc
[[ -d "$HOME/.vite-plus/bin" ]] && path=("$HOME/.vite-plus/bin" $path)

[[ -a "$HOME/.localrc" ]] && source "$HOME/.localrc"

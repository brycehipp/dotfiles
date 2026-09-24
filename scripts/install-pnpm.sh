#!/usr/bin/env zsh

# Standalone pnpm into $PNPM_HOME (not Homebrew). PATH is set in .zshenv.

set -euo pipefail

SCRIPT_DIR=${0:A:h}

PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
PNPM_BIN="$PNPM_HOME/bin/pnpm"

# Hang-safe: a broken install hard-links pnpm to the pnx alias script.
pnpm_cli_ok() {
  [[ -x "$PNPM_BIN" ]] || return 1
  grep -q 'exec "${self%/\*}/pnpm" dlx' "$PNPM_BIN" 2>/dev/null && return 1
  ver=$("$PNPM_BIN" --version 2>/dev/null) || return 1
}

if [[ "${1:-}" == --check ]]; then
  pnpm_cli_ok
  exit $?
fi

source "$SCRIPT_DIR/ui.sh"

if pnpm_cli_ok; then
  success "pnpm already installed ($ver)"
  exit 0
fi

if [[ -e "$PNPM_BIN" ]]; then
  info "Repairing broken pnpm shims in $PNPM_HOME/bin"
  rm -f "$PNPM_HOME/bin"/pn "$PNPM_HOME/bin"/pnpm "$PNPM_HOME/bin"/pnpx "$PNPM_HOME/bin"/pnx
fi

info "Installing pnpm (standalone) into $PNPM_HOME"
export PNPM_HOME
tmp_rc="$(mktemp)"
curl -fsSL https://get.pnpm.io/install.sh | env SHELL=/bin/sh ENV="$tmp_rc" /bin/sh -
rm -f "$tmp_rc"

pnpm_cli_ok || fail "pnpm install finished, but $PNPM_BIN is missing or broken"
success "Installed pnpm $ver"

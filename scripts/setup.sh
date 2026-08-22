#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR=${0:A:h}
RUN_MACHINE=true
RUN_DOTFILES=true

print_usage() {
  cat <<'EOF'
Usage: setup.sh [--machine-only | --dotfiles-only] [--help]

Options:
  --machine-only   Run machine setup steps only
  --dotfiles-only  Run dotfiles install/linking only
  -h, --help       Show this help message
EOF
}

for arg in "$@"
do
  case "$arg" in
    --machine-only)
      RUN_MACHINE=true
      RUN_DOTFILES=false
      ;;
    --dotfiles-only)
      RUN_MACHINE=false
      RUN_DOTFILES=true
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      print_usage >&2
      exit 1
      ;;
  esac
done

if [[ "$RUN_DOTFILES" == "true" ]]
then
  "$SCRIPT_DIR/install-dotfiles.sh"
fi

if [[ "$RUN_MACHINE" == "true" ]]
then
  "$SCRIPT_DIR/setup-machine.sh"
fi

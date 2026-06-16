lazy_load_nvm() {
  local arch="$(uname -m)"
  local arch_dir="${HOME}/.${arch}"
  local nvm_path="$HOME/.nvm"

  if [[ -d "$arch_dir/nvm" ]]; then
    nvm_path="$arch_dir/nvm"
  fi

  unfunction nvm node npm npx pnpm yarn corepack 2>/dev/null || true

  export NVM_DIR="$nvm_path"
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
}

nvm() {
  lazy_load_nvm
  nvm "$@"
}

node() {
  lazy_load_nvm
  node "$@"
}

npm() {
  lazy_load_nvm
  npm "$@"
}

npx() {
  lazy_load_nvm
  npx "$@"
}

pnpm() {
  lazy_load_nvm
  pnpm "$@"
}

yarn() {
  lazy_load_nvm
  yarn "$@"
}

corepack() {
  lazy_load_nvm
  corepack "$@"
}

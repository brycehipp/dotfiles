function () {
  local arch=$(uname -m)
  local arch_dir=${HOME}/.${arch}

  local nvm_path="$HOME/.nvm"

  if [[ -d $arch_dir/nvm ]]; then
    nvm_path=$arch_dir/nvm
  fi

  export NVM_DIR="$nvm_path"
  # todo: what if HOMEBREW isn't available yet?
  # todo: see what these should be if nvm installed normally (not with homebrew)
  [ -s "${HOMEBREW}/opt/nvm/nvm.sh" ] && \. "${HOMEBREW}/opt/nvm/nvm.sh"
  [ -s "${HOMEBREW}/opt/nvm/etc/bash_completion.d/nvm" ] && \. "${HOMEBREW}/opt/nvm/etc/bash_completion.d/nvm"
}
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

function () {
  local arch=$(uname -m)
  local arch_dir=${HOME}/.${arch}

  local brew_path=''

  if [[ -a $arch_dir/homebrew/bin/brew ]]; then
    brew_path=$arch_dir/homebrew
  elif [[ -a $HOME/homebrew/bin/brew ]]; then
    brew_path=$HOME/homebrew
  fi

  # If we're using a custom homebrew path then make sure that homebrew loads up
  if [ ! -z "$brew_path" ]
  then
    export HOMEBREW="$brew_path"
    # Make sure casks go to this user's home
    export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

    # Include homebrew installed in my home dir
    eval "$(${brew_path}/bin/brew shellenv)"
  fi
}
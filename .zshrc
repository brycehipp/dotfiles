# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a $HOME/.localrc ]]
then
  source $HOME/.localrc
fi

# Make sure VS Code waits till closed before sending close signal
export EDITOR='code --wait'

# Setup nvm and completions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use this user's homebrew install if it exists
if [[ -a $HOME/homebrew/bin/brew ]]
then
  export HOMEBREW="$HOME/homebrew"
  # Make sure casks go to this user's home
  export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

  # Include homebrew installed in my home dir
  eval "$(~/homebrew/bin/brew shellenv)"
fi

# Pasting with tabs shouldn't perform autocompletion
zstyle ':completion:*' insert-tab pending

# Load up custom files
CONFIG_FILES=($HOME/.dotfiles/*.zsh)
for file in ${CONFIG_FILES}
do
  source $file
done
unset CONFIG_FILES

# Load up Prezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

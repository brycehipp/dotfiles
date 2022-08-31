# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a $HOME/.localrc ]]
then
  source $HOME/.localrc
fi

# Make sure VS Code waits till closed before sending close signal
export EDITOR='code --wait'

# Pasting with tabs shouldn't perform autocompletion
zstyle ':completion:*' insert-tab pending

# Load up Prezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# Load up custom files
CONFIG_FILES=($HOME/.dotfiles/shell/*.zsh)
for file in ${CONFIG_FILES}
do
  source $file
done
unset CONFIG_FILES

# todo: need to conditionally run this if the command is available
# initialize starship prompt
eval "$(starship init zsh)"


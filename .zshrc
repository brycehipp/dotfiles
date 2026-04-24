# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

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

# define oh-my-zsh plugins
plugins=(
  copypath # Copy current path to clipboard
  copyfile # Copy a file's contents to clipboard
  colorize # Syntax highlighting when viewing file's contents
  colored-man-pages # Colorize man pages
  git # git aliases and functions - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  gitfast # git completion. Faster than what zsh provides
  brew # brew aliases
  npm # npm aliases and completion
  history # history aliases
  docker # docker aliases and completion
  docker-compose # docker-compose aliases and completion
  encode64 # encode and decode base64 aliases
  aws # awscli completion and commands
  macos # macOS aliases
  z # Allows jumping between "frecency" directories using z
)

# initalize oh-my-zsh
source $ZSH/oh-my-zsh.sh

## oh-my-zsh plugins installed with homebrew ##
# Fish-like autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Fish-like syntax highlighting.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
eval "$(/opt/homebrew/bin/brew shellenv)"

# bun completions
[ -s "/Users/bryce/.bun/_bun" ] && source "/Users/bryce/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# opencode
export OCX_PROFILE=default

# peon-ping quick controls
alias peon="bash /Users/bryce/.claude/hooks/peon-ping/peon.sh"
[ -f /Users/bryce/.claude/hooks/peon-ping/completions.bash ] && source /Users/bryce/.claude/hooks/peon-ping/completions.bash

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

# pnpm
export PNPM_HOME="/Users/bryce/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

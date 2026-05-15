# zmodload zsh/zprof

# Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
[[ -a "$HOME/.localrc" ]] && source "$HOME/.localrc"

# export EDITOR='zed --wait'

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
source "$ZSH/oh-my-zsh.sh"

# Load up custom files
CONFIG_FILES=($HOME/.dotfiles/shell/*.zsh)
for file in $CONFIG_FILES
do
  source "$file"
done
unset CONFIG_FILES

# syntax highlighting
command -v zsh-patina >/dev/null && eval "$(zsh-patina activate)"

# initialize starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
case ":$PATH:" in
  *":$BUN_INSTALL/bin:"*) ;;
  *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
esac
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# peon-ping quick controls
alias peon="bash $HOME/.claude/hooks/peon-ping/peon.sh"
[[ -f "$HOME/.claude/hooks/peon-ping/completions.bash" ]] && source "$HOME/.claude/hooks/peon-ping/completions.bash"

# Vite+ bin (https://viteplus.dev)
[[ -s "$HOME/.vite-plus/env" ]] && . "$HOME/.vite-plus/env"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# zprof

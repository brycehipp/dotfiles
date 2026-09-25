# zmodload zsh/zprof

# Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"

export VISUAL='zed'
export EDITOR='vim'
export GIT_EDITOR='zed --wait'

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

# pnpm completions (overrides stale zcompdump `_pnpm` mapping)
command -v pnpm >/dev/null && eval "$(pnpm completion zsh)"

# Vite+ vp() wrapper (PATH is set in .zshenv)
[[ -s "$HOME/.vite-plus/env" ]] && . "$HOME/.vite-plus/env"

# peon-ping quick controls
alias peon="bash $HOME/.claude/hooks/peon-ping/peon.sh"
[[ -f "$HOME/.claude/hooks/peon-ping/completions.bash" ]] && source "$HOME/.claude/hooks/peon-ping/completions.bash"

# initialize MSR Dotfiles
[[ -n "$MSR_DEV_ENV_TOOLS_HOME" && -f "$MSR_DEV_ENV_TOOLS_HOME/dotfiles/msr-dotfiles.sh" ]] && \
  source "$MSR_DEV_ENV_TOOLS_HOME/dotfiles/msr-dotfiles.sh"

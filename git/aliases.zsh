# Use `hub` as our git wrapper:
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# Git shortcuts
alias git.files_changed='git diff --name-only'
alias git.release_notes='git log --oneline --no-merges `git describe --abbrev=0 --tags`..HEAD | cut -c 9- | sort | nano'
alias git.fix='git diff --name-only | uniq | xargs code'

# Alias to match the git oh-my-zsh plugin
alias gfa='git fetch --all'

# Aliases for pushing and setting upstream
alias gpur='git push -u raptor'
alias gpup='git push -u origin'
alias gpus='git push -u tli'

alias gupu='git pull --rebase && git push'

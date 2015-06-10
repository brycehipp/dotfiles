# Use `hub` as our git wrapper:
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# Git shortcuts
alias git.files_changed='git diff --name-only'
alias git.release_notes='git log --oneline --no-merges `git describe --abbrev=0 --tags`..HEAD | cut -c 9- | sort | nano'
alias gfa='git fetch --all'

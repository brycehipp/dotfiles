source $PLUGIN_HOME/zsh-git-prompt/zshrc.sh

PROMPT='
$(_user_host)${_current_dir} $(git_super_status) $(_ruby_version)
%(?.%F{white}.%F{red})▶%f '

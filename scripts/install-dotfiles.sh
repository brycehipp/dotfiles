#!/usr/bin/env zsh

DOTFILES_ROOT=$HOME/.dotfiles
SCRIPT_DIR=${0:A:h}

set -euo pipefail

source "$SCRIPT_DIR/ui.sh"

echo ''

setup_gitconfig () {
  local git_authorname="$(git config --global --get user.name || true)"
  local git_authoremail="$(git config --global --get user.email || true)"
  local git_editor="$(git config --global --get core.editor || true)"
  local git_excludesfile="$(git config --global --get core.excludesfile || true)"

  if [[ -z "$git_authorname" || -z "$git_authoremail" || -z "$git_editor" || -z "$git_excludesfile" ]]
  then
    info 'setup gitconfig'

    if [[ -z "$git_authorname" ]]
    then
      user ' - What is your Git author name?'
      read -e git_authorname
    fi

    if [[ -z "$git_authoremail" ]]
    then
      user ' - What is your Git author email?'
      read -e git_authoremail
    fi

    cp "$DOTFILES_ROOT/.gitignore-global" "$HOME/.gitignore-global"

    git config --global init.defaultBranch main

    git config --global user.name "${git_authorname}"
    git config --global user.email "${git_authoremail}"

    git config --global core.autocrlf input
    git config --global core.editor "zed --wait"
    git config --global core.excludesfile "${HOME}/.gitignore-global"

    success 'gitconfig'
  fi
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [[ -f "$dst" || -d "$dst" || -L "$dst" ]]
  then

    if [[ "$overwrite_all" == "false" && "$backup_all" == "false" && "$skip_all" == "false" ]]
    then

      local currentSrc="$(readlink "$dst")"

      if [[ "$currentSrc" == "$src" ]]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -k 1 action
        echo ''

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [[ "$overwrite" == "true" ]]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [[ "$backup" == "true" ]]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [[ "$skip" == "true" ]]
    then
      success "skipped $src"
    fi
  fi

  if [[ "$skip" != "true" ]]  # "false" or empty
  then
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    success "linked $src to $dst"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  link_file "$DOTFILES_ROOT/.zshrc" "$HOME/.zshrc"
  link_file "$DOTFILES_ROOT/.gitignore-global" "$HOME/.gitignore-global"
  link_file "$DOTFILES_ROOT/config/starship.toml" "$HOME/.config/starship.toml"
  link_file "$DOTFILES_ROOT/config/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
  link_file "$DOTFILES_ROOT/config/zed/settings.json" "$HOME/.config/zed/settings.json"
  link_file "$DOTFILES_ROOT/config/zed/keymap.json" "$HOME/.config/zed/keymap.json"
}

setup_gitconfig
install_dotfiles

echo ''
echo '  All installed!'

#! /bin/bash

DOTFILES_ROOT=$HOME/.dotfiles

set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig () {
  if ! [ -f $HOME/.gitignore-global ]
  then
    info 'setup gitconfig'

    user ' - What is your Git author name?'
    read -e git_authorname
    user ' - What is your Git author email?'
    read -e git_authoremail

    cp $DOTFILES_ROOT/.gitignore-global $HOME/.gitignore-global

    git config --global init.defaultBranch main

    git config --global user.name "${git_authorname}"
    git config --global user.email "${git_authoremail}"

    git config --global core.autocrlf true
    git config --global core.editor "code --wait"
    git config --global core.excludesfile "${HOME}/.gitignore-global"

    success 'gitconfig'
  fi
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

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

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  link_file "$DOTFILES_ROOT/.zshrc" "$HOME/.zshrc"
  link_file "$DOTFILES_ROOT/.wezterm.lua" "$HOME/.wezterm.lua"
  link_file "$DOTFILES_ROOT/starship.toml" "$HOME/.config/starship.toml"
}

setup_gitconfig
install_dotfiles

echo ''
echo '  All installed!'
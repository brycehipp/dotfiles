# dotfiles

My personal dotfiles.

## Install

Bootstrap your shell.

```sh
git clone git@github.com:brycehipp/dotfiles.git ~/.dotfiles
~/.dotfiles/bootstrap.sh
```

Perform a first time setup.

```sh
~/.dotfiles/setup.sh
```

## Customizations

You may create `*.work.zsh` files for anything you'd like to customize that shouldn't be part of the repo. The files will automatically be loaded up and ignored by git.

Additionally, `~/.localrc` will be loaded up if it exists.

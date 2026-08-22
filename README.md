# dotfiles

My personal dotfiles.

## Install

One-command machine setup (recommended for first-time setup).

```sh
git clone git@github.com:brycehipp/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/setup.sh
```

Run setup for a specific scope via flags.

```sh
# Machine setup only
~/.dotfiles/scripts/setup.sh --machine-only

# Dotfiles only
~/.dotfiles/scripts/setup.sh --dotfiles-only
```

Install/update dotfiles directly.

```sh
~/.dotfiles/scripts/install-dotfiles.sh
```

Run machine setup steps directly.

```sh
~/.dotfiles/scripts/setup-machine.sh
```

### Re-running dotfiles setup

Both of these are safe to run repeatedly:

- `~/.dotfiles/scripts/setup.sh --dotfiles-only`
- `~/.dotfiles/scripts/install-dotfiles.sh`

They will relink missing files, skip links that already point at your dotfiles, and prompt for what to do when destination files already exist (`skip`, `overwrite`, or `backup`).

After opening a new shell, run `df.update` to pull repository updates, link any newly added dotfiles, and install new Brewfile dependencies without upgrading existing packages.

Run `df.doctor` to see how much of the managed dotfiles and Git configuration is installed. Use `df.doctor --fix` to apply missing configuration with the existing installer.

## Customizations

You may create `*.local.zsh` files for anything you'd like to customize that shouldn't be part of the repo. The files will automatically be loaded up and ignored by git.

Additionally, `~/.localrc` will be loaded up if it exists.

# dotfiles

My personal dotfiles.

## Install

One-command machine setup (recommended for first-time setup).

```sh
git clone git@github.com:brycehipp/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/setup.sh
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

`~/.dotfiles/scripts/install-dotfiles.sh` is safe to run repeatedly. It will relink missing files, skip links that already point at your dotfiles, and prompt for what to do when destination files already exist (`skip`, `overwrite`, or `backup`).

After opening a new shell, run `df.update` to pull repository updates, link any newly added dotfiles, and install new Brewfile dependencies without upgrading existing packages.

Homebrew packages are split across:

- `Brewfile` - always installed
- `Brewfile.agents` - AI / agent tooling (optional)
- `Brewfile.work` - work tooling (optional)

Optional sets are controlled by `brew-profiles.local` (gitignored). Machine setup prompts for agents/work and writes that file. Edit it later, or run:

```sh
~/.dotfiles/scripts/brew.sh --all
~/.dotfiles/scripts/brew.sh --agents
~/.dotfiles/scripts/brew.sh --work
```

Run `df.doctor` to see how much of the managed dotfiles and Git configuration is installed. Use `df.doctor --fix` to apply missing configuration with the existing installer.

## Customizations

You may create `*.local.zsh` files for anything you'd like to customize that shouldn't be part of the repo. The files will automatically be loaded up and ignored by git.

Additionally, `~/.localrc` will be loaded up if it exists.

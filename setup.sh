#! /bin/bash

cd ~/Development
mkdir _commands
mkdir _commands/zsh
mkdir _commands/zsh/plugins

cd ~/Development/_commands/zsh/plugins

git clone git@github.com:olivierverdier/zsh-git-prompt.git

brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

nvm alias default node

defaults write -g ApplePressAndHoldEnabled -bool false

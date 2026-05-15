# install Starship prompt and Nerd Font for it
brew install starship
brew tap homebrew/cask-fonts && brew install --cask font-fira-code-nerd-font
brew install --cask font-maple-mono-nf

mkdir ~/.config && touch ~/.config/starship.toml

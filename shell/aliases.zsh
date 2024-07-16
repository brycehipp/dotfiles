# Enable aliases to be sudo'ed
alias sudo='sudo '

# Set something for python since it's not installed by default anymore
alias python='python3'

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; $(update.brew)'
alias update.brew="brew update; brew upgrade; brew cleanup;"

# IP addresses
alias localip="ipconfig getifaddr en0"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias spoof_mac="sudo ifconfig en0 ether fa:ke:ma:c"

# Flush Directory Service cache
alias dnsflush="dscacheutil -flushcache && killall -HUP mDNSResponder"

###### Cleanup items ######

# Clean up LaunchServices to remove duplicates in the "Open With" menu
alias cleanup.ls="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup.dsstore="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple's System Logs to improve shell startup speed
alias cleanup.trash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# zsh reloads
alias z.reload='exec zsh'
alias z.reload.full='. ~/.zshrc'

# Edit files
alias edit.z='code ~/.zshrc'
alias edit.ohmyzsh='code ~/.oh-my-zsh'
alias edit.hosts='code /etc/hosts'
alias edit.ssh='code ~/.ssh/config'
alias edit.ngrok='code ~/.ngrok2/ngrok.yml'

# Finder shortcuts
alias finder.show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias finder.hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias desktop.show="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias desktop.hide="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

# Fun
alias rainbow='yes "$(seq 231 -1 16)" | while read i; do printf "\x1b[48;5;${i}m\n"; sleep .02; done'

# Safeguard
alias rm='rm -i'

# npm/yarn
alias yarn.please="printf 'Removing node_modules folder...' && rm -rf node_modules && yarn"
alias npm.please="printf 'Removing node_modules folder...' && rm -rf node_modules && npm i"

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Git shortcuts
alias git.files_changed='git diff --name-only'
alias git.release_notes='git log --oneline --no-merges `git describe --abbrev=0 --tags`..HEAD | cut -c 9- | sort | nano'
alias git.fix='git diff --name-only | uniq | xargs code'

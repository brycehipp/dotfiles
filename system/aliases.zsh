# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias spoof_mac="sudo ifconfig en0 ether fa:ke:ma:c"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

###### Cleanup items ######

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias cleanup.ls="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias cleanup.trash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Edit randy files
alias edit.hosts='code /etc/hosts'
alias edit.httpd='code /etc/apache2/httpd.conf'
alias edit.php='code /etc/php.ini'
alias edit.vhosts='code /etc/apache2/extra/httpd-vhosts.conf'
alias edit.mod_jk='code /etc/apache2/mod_jk.conf'
alias edit.ssh='code ~/.ssh/config'
alias edit.ngrok='code ~/.ngrok2/ngrok.yml'

# Move Directories
alias cd.sites='cd ~/Sites'
alias cd.development='cd ~/Development'
alias cd.coldfusion='cd /Applications/Coldfusion10/cfusion/'
alias cd.coldfusion.logs='cd /Applications/Coldfusion10/cfusion/logs'
alias cd.edge='cd ~/Sites/edge/'
alias cd.scheduled_tasks='cd ~/Sites/scheduled-tasks/'
alias cd.dotfiles='cd ~/Development/dotfiles/_mine/'
alias cd.til='cd ~/Development/_til/'
alias cd.doc_server='cd ~/Sites/doc-server/'

# Finder shortcuts
alias finder.show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias finder.hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias desktop.show="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias desktop.hide="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

# Coldfusion shortcuts
alias coldfusion='/Applications/Coldfusion10/cfusion/bin/coldfusion'

# MySQL shortcuts
alias mysql.connect='mysql -u root -p -A'
alias mysql.start='brew services start mysql'
alias mysql.stop='brew services stop mysql'
alias mysql.restart='brew services restart mysql'

# FTP shortcuts
alias ftp.start='sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist'
alias ftp.stop='sudo -s launchctl unload -w /System/Library/LaunchDaemons/ftp.plist'

# Python Shortcuts
alias python.web='python -m SimpleHTTPServer'

# Sencha
alias sencha="~/bin/Sencha/Cmd/4.0.1.45/sencha"

# Application Links
alias subl="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"

# Fun
alias makecoffee='printf "\xE2\x98\x95\n"'
alias rainbow='yes "$(seq 231 -1 16)" | while read i; do printf "\x1b[48;5;${i}m\n"; sleep .02; done'

# Safeguard
alias rm='rm -i'

alias lx='ls -X'

# VPN
alias vpn="sudo openconnect --no-dtls --servercert sha256:66811044a0da0565b22676d52a15f6b7bff03b4ecb20b8ad4a7bb6fd20766885 --quiet --user=bhipp asa-quantumedgetechnology.edgewebhosting.net"
alias vpn.t="sudo openconnect --no-dtls --servercert sha256:a71d3c7523ab937c430c8348b27da7e183885f79b60553f782b4df9e86e1d90d --quiet --user=bryce.hipp f0096.edgewebhosting.net"

# Ngrok
alias ngrok.8080='ngrok http 8080 -host-header="localhost:8080"'

# Yarn
alias yarn.please="rm -rf node_modules && yarn"

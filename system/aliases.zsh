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

# Edit randy files
alias edit.hosts='subl /etc/hosts'
alias edit.httpd='subl /etc/apache2/httpd.conf'
alias edit.php='subl /etc/php.ini'
alias edit.vhosts='subl /etc/apache2/extra/httpd-vhosts.conf'
alias edit.mod_jk='subl /etc/apache2/mod_jk.conf'
alias edit.ssh='subl ~/.ssh/config'

# Move Directories
alias cd.sites='cd ~/Sites'
alias cd.development='cd ~/Development'
alias cd.coldfusion='cd /Applications/Coldfusion10/cfusion/'
alias cd.coldfusion.logs='cd /Applications/Coldfusion10/cfusion/logs'
alias cd.edge='cd ~/Sites/edge/'
alias cd.scheduled_tasks='cd ~/Sites/scheduled-tasks/'

# Finder shortcuts
alias finder.show_files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias finder.hide_files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Coldfusion shortcuts
alias coldfusion='/Applications/Coldfusion10/cfusion/bin/coldfusion'

# MySQL shortcuts
alias mysql.connect='mysql -u root -p -A'

# Sencha
alias sencha="~/bin/Sencha/Cmd/4.0.1.45/sencha"

# Application Links
alias subl="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"

# Fun
alias makecoffee='printf "\xE2\x98\x95\n"'

# Safeguard
alias rm='rm -i'

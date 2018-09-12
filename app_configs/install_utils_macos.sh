#!/bin/zsh
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

sudo -v # ask for password

# install homebrew
[ $commands[brew] ] || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew list coreutils >/dev/null || brew install coreutils # http://www.gnu.org/software/coreutils/manual/coreutils.pdf
brew list grep >/dev/null || brew install grep
brew list openssh >/dev/null || brew install openssh
brew list screen >/dev/null || brew install screen

brew list zsh >/dev/null || brew install zsh
brew list tldr >/dev/null || brew install tldr # https://github.com/tldr-pages/tldr

brew cask list qlstephen >/dev/null || brew cask install qlstephen #quick look for plain text files
brew cask list qlmarkdown >/dev/null || brew cask install qlmarkdown #quick for markdown files
brew cask list qlcolorcode >/dev/null || brew cask install qlcolorcode #quick look for src files with syntax highlighting

brew list calc >/dev/null || brew install calc # http://www.isthe.com/chongo/tech/comp/calc/

brew list git >/dev/null || brew install git
brew list loc >/dev/null || brew install loc
brew list gource >/dev/null || brew install gource # software version control visualization http://gource.io

brew list pwgen >/dev/null || brew install pwgen
brew list qoomon/tab/ppgen >/dev/null || brew install qoomon/tab/ppgen # passphrase generator; https://github.com/qoomon/passphrase-generator

brew list bat >/dev/null || brew install bat # cat with highlighing and git support; https://github.com/sharkdp/bat

brew list vim >/dev/null || brew install vim --with-override-system-vi
brew list micro >/dev/null || brew install micro # https://github.com/zyedidia/micro
brew list fzf >/dev/null || brew install fzf # https://github.com/junegunn/fzf # install shell extensions /usr/local/opt/fzf/install
# brew list fzy >/dev/null || brew install fzy # https://github.com/jhawthorn/fzy
brew list htop >/dev/null || brew install htop # better top
brew list nmap >/dev/null || brew install nmap
brew list mtr >/dev/null || brew install mtr # ping and trace combined : http://www.bitwizard.nl/mtr/
brew list tmux >/dev/null || brew install tmux # https://github.com/tmux/tmux
brew list fd >/dev/null || brew install fd # A simple, fast and user-friendly alternative to 'find'https://github.com/sharkdp/fd
# brew list the_silver_searcher >/dev/null || brew install the_silver_searcher # command: ag; better find https://github.com/ggreer/the_silver_searcher
brew list irssi >/dev/null || brew install irssi # https://github.com/irssi/irssi
brew list watch >/dev/null || brew install watch # infinite command loop
brew list watchman >/dev/null || brew install watchman # a file watching service https://facebook.github.io/watchman 

brew list tree >/dev/null || brew install tree
brew list pstree >/dev/null || brew install pstree
brew list ncdu >/dev/null || brew install ncdu

brew list ifstat >/dev/null || brew install ifstat
brew list ipcalc >/dev/null || brew install ipcalc

brew list httpie >/dev/null || brew install httpie # better alternative to curl
brew list httpry >/dev/null || brew install httpry # http sniffer https://github.com/jbittel/httpry
# brew list w3m >/dev/null || brew install w3m # terminal browser

brew list oath-toolkit >/dev/null || brew install oath-toolkit # generate OTP Codes e.g. Google Authenticator => oathtool --totp --base32 <Secret>
brew list zbar >/dev/null || brew install zbar # read qr-code images e.g. command: zbarimg qr.png
# brew list tesseract >/dev/null || brew install tesseract --with-all-languages # ocr https://github.com/tesseract-ocr/tesseract

brew list siege >/dev/null || brew install siege # benchmark http # https://github.com/JoeDog/siege
brew list vegeta >/dev/null || brew install vegeta # benchmark http # https://github.com/tsenart/vegeta
brew list k6 >/dev/null || brew install k6 # benchmark http # https://github.com/loadimpact/k6

brew list jq >/dev/null || brew install jq # json parser

brew list gotty >/dev/null || brew install yudai/gotty/gotty

# brew list dnsmasq >/dev/null || brew install dnsmasq # e.g. wildcard dns server *.localhost \
# && sudo mkdir -p /etc/resolver || sudo tee /etc/resolver/localhost <<< 'nameserver 127.0.0.1' >/dev/null # add dnsmasq as resolver
# brew list socat >/dev/null || brew install socat

brew list ctop >/dev/null || brew install ctop # htop for docker

brew list node >/dev/null || brew install node # js runtime evironment
npm list --global http-server >/dev/null || npm install --global http-server # http server to serve current directory
npm list --global localtunnel >/dev/null || npm install --global localtunnel

# brew cask list java >/dev/null || brew cask install java
# brew list jenv >/dev/null || brew install jenv

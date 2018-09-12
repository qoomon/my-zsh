#!/bin/zsh
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

sudo -v # ask for password

# install homebrew
[ $commands[brew] ] || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle

npm list --global http-server >/dev/null || npm install --global http-server # http server to serve current directory
npm list --global localtunnel >/dev/null || npm install --global localtunnel

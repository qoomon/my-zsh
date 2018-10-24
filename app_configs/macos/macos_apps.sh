#!/bin/bash
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

# install commandline tools
[ -e "$(xcode-select --print-path)" ] || sudo xcode-select --install
# install homebrew
[ $commands[brew] ] || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# install brew bundle
brew bundle

# install global node packages
npm install --global http-server # http server to serve current directory
npm install --global localtunnel

# install stared atom packages
apm stars --install

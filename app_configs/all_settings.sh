#!/bin/bash
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

echo ./macos/macos_settings.sh
./macos/macos_settings.sh

echo ./git/git_settings.sh
./git/git_settings.sh

echo ./docker/docker_settings.sh
./docker/docker_settings.sh

echo ./vim/vim_settings.sh
./vim/vim_settings.sh

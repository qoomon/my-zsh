#!/bin/zsh
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

cp -i config.json $HOME/.docker/config.json

# install zsh completions
DOCKER_APP_COMPLETION_PATH='/Applications/Docker.app/Contents/Resources/etc'
if [ -e "$DOCKER_APP_COMPLETION_PATH" ]; then
  ZSH_SITE_FUNCTIONS_DIR='/usr/local/share/zsh/site-functions'
  for comp_file in '/Applications/Docker.app/Contents/Resources/etc/'*'.zsh-completion'; do
    comp_target_file="$comp_file"
    comp_target_file="${comp_target_file##*/}"
    comp_target_file="${comp_target_file%.zsh-completion}"
    comp_target_file="$ZSH_SITE_FUNCTIONS_DIR/_${comp_target_file}"
    if [ ! -e "$comp_target_file" ]; then
      ln -s "$comp_file" "$comp_target_file"
    fi
  done
fi

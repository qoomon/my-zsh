#!/bin/bash
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

if [ "$(uname)" = "Darwin" ]; then
  # workaround for slow docker compose
  grep -q -F 'localunixsocket' /etc/hosts || echo '127.0.0.1       localunixsocket' | sudo tee -a /etc/hosts

  # install zsh completions
  DOCKER_APP_COMPLETION_PATH='/Applications/Docker.app/Contents/Resources/etc'
  ZSH_SITE_FUNCTIONS_DIR='/usr/local/share/zsh/site-functions'
  if [ -e "$DOCKER_APP_COMPLETION_PATH" ] && [ -e "$ZSH_SITE_FUNCTIONS_DIR" ]; then
    ln -s "$DOCKER_APP_COMPLETION_PATH/docker.zsh-completion"         "$ZSH_SITE_FUNCTIONS_DIR/_docker"
    ln -s "$DOCKER_APP_COMPLETION_PATH/docker-compose.zsh-completion" "$ZSH_SITE_FUNCTIONS_DIR/_docker-compose"
    ln -s "$DOCKER_APP_COMPLETION_PATH/docker-machine.zsh-completion" "$ZSH_SITE_FUNCTIONS_DIR/_docker-machine"
  fi
fi

#!/bin/zsh
SELF_DIR="$(dirname "$0")"
cd "$SELF_DIR"

cp -i config.json $HOME/.docker/config.json

if [ "$(uname)" = "Darwin" ]; then
  # workaround for slow docker compose
  grep -q -F 'localunixsocket' /etc/hosts || echo '127.0.0.1       localunixsocket' | sudo tee -a /etc/hosts
  
  # install zsh completions
  DOCKER_APP_COMPLETION_PATH='/Applications/Docker.app/Contents/Resources/etc'
  ZSH_SITE_FUNCTIONS_DIR='/usr/local/share/zsh/site-functions'
  [ -e "$DOCKER_APP_COMPLETION_PATH/docker.zsh-completion" ]         || ln -s "$ZSH_SITE_FUNCTIONS_DIR/_docker"         "$DOCKER_APP_COMPLETION_PATH/docker.zsh-completion"
  [ -e "$DOCKER_APP_COMPLETION_PATH/docker-compose.zsh-completion" ] || ln -s "$ZSH_SITE_FUNCTIONS_DIR/_docker-compose" "$DOCKER_APP_COMPLETION_PATH/docker-compose.zsh-completion"
  [ -e "$DOCKER_APP_COMPLETION_PATH/docker-machine.zsh-completion" ] || ln -s "$ZSH_SITE_FUNCTIONS_DIR/_docker-machine" "$DOCKER_APP_COMPLETION_PATH/docker-machine.zsh-completion"
fi


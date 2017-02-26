SELF_DIR="$(dirname "${0:A}")"
cd "$SELF_DIR"

cp -i config.json $HOME/.docker/config.json

DOCKER_APP_COMPLETION_PATH='/Applications/Docker.app/Contents/Resources/etc'
if [ -e "$DOCKER_APP_COMPLETION_PATH" ]; then
  ZSH_SITE_FUNCTIONS_DIR='/usr/local/share/zsh/site-functions'
  test ! -e "$ZSH_SITE_FUNCTIONS_DIR/_docker"         && ln -s "$DOCKER_APP_COMPLETION_PATH/docker.zsh-completion"         "$ZSH_SITE_FUNCTIONS_DIR/_docker"
  test ! -e "$ZSH_SITE_FUNCTIONS_DIR/_docker-compose" && ln -s "$DOCKER_APP_COMPLETION_PATH/docker-compose.zsh-completion" "$ZSH_SITE_FUNCTIONS_DIR/_docker-compose"
  test ! -e "$ZSH_SITE_FUNCTIONS_DIR/_docker-machine" && ln -s "$DOCKER_APP_COMPLETION_PATH/docker-machine.zsh-completion" "$ZSH_SITE_FUNCTIONS_DIR/_docker-machine"
fi

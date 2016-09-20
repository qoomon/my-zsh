export DOCKER_HOST=unix:///var/run/docker.sock

function docker_connect {
  docker exec -i -t $1 sh
}

# brew install docker-clean

# docker run -it --rm <imageName> <command>  # one shot command. remove container after run

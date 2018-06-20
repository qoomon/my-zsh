function docker-registry-image-tags {
  
  local insecureFlag=''
  if [ "$1" = '--insecure' ]; then 
    insecureFlag='--insecure'
    shift
  fi
  
  local repository=$(echo $1 | sed -E 's|((([^/]+)/)?([^/]+)/)?([^/]+)|\3|')
  local image_namespace=$(echo $1 | sed -E 's|((([^/]+)/)?([^/]+)/)?([^/]+)|\4|')
  local image_name=$(echo $1 | sed -E 's|((([^/]+)/)?([^/]+)/)?([^/]+)|\5|')
  
  local authorizationHeader=''
  if [ -z "$repository" ]; then 
    repository='registry.hub.docker.com'
    if [ -z "$image_namespace" ]; then 
      image_namespace="library"
    fi
    local token="$(curl -sSL "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${image_namespace}/${image_name}:pull" | jq --raw-output .token)"
    authorizationHeader="Authorization: Bearer ${token}"
  fi

  local response=$(curl -sSL $insecureFlag -H "$authorizationHeader" "https://${repository}/v2/${image_namespace}/${image_name}/tags/list")
  if echo $response | jq --exit-status 'has("errors")' >/dev/null; then
    echo $response | jq  -r '.errors[].message'
  else
    echo $response | jq  -r '.tags[]' | sort c
  fi
}

autoload +X -U colors && colors
function docker-examples {
  echo " ${fg_bold[magenta]}-${reset_color} ${fg_bold[yellow]}Execute sommand in running container${reset_color}"
  echo "     ${fg_bold[green]}docker${reset_color} exec -it ${fg_bold[blue]}container${reset_color} ${fg_bold[blue]}command${reset_color} "
  
  echo " ${fg_bold[magenta]}-${reset_color} ${fg_bold[yellow]}Run container as a command${reset_color}"
  echo "     ${fg_bold[green]}docker${reset_color} run -it --rm ${fg_bold[blue]}image_name${reset_color}"
}



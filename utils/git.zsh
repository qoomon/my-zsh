
function git_repository_version_latest {
  git describe --all --tags --match 'v*' --first-parent --abbrev=0 2>/dev/null| sed 's|^v||'
}

function git_repository_version_bump_recommendation {
  local latest_version=$(git_repository_version_latest)
  local latest_version_array=($(echo "$latest_version" | grep -E -o "[^.-]+" ))

  latest_version_array[4]=$(echo "$latest_version" | sed "s|^[^-]*||" )
  next_version_array=($latest_version_array)
  if [ -n "$(git log --grep '^BREAKING CHANGE')" ]; then
    echo "major"
  elif [ -n "$(git log --grep '^feat')" ]; then
    echo "minor"
  else
    echo "patch"
  fi
}

function git_repository_version_next {
  local latest_version=$(git_repository_version_latest)
  local -a latest_version_array; latest_version_array=($(echo "$latest_version" | grep -E -o "[^.-]+" ))
  latest_version_array[4]=$(echo "$latest_version" | sed "s|^[^-]*||" )

  local next_version_bump_recommendation=$(git_repository_version_bump_recommendation)
  local -a next_version_array; next_version_array=($latest_version_array)
  if [ "$next_version_bump_recommendation" = "major" ]; then
    next_version_array[1]=$((${next_version_array[1]}+1))
    next_version_array[2]=0
    next_version_array[3]=0
  elif [ "$next_version_bump_recommendation" = "minor" ]; then
    next_version_array[2]=$((${next_version_array[2]}+1))
    next_version_array[3]=0
  else
    next_version_array[3]=$((${next_version_array[3]}+1))
  fi

  next_version="${next_version_array[1]}.${next_version_array[2]}.${next_version_array[3]}${next_version_array[4]}"
  echo "$next_version"
}

function git_repository_version_compare {
  local current_version=${1:-}
  local -a current_version_array; current_version_array=($(echo "$current_version" | grep -E -o "[^.-]+" ))

  local next_version=$(git_repository_version_next)
  local -a next_version_array; next_version_array=($(echo "$next_version" | grep -E -o "[^.-]+" ))

  if [ ${current_version_array[1]} -lt ${next_version_array[1]} ] \
  || [ ${current_version_array[2]} -lt ${next_version_array[2]} ] \
  || [ ${current_version_array[3]} -lt ${next_version_array[3]} ]; then
    >&2 echo "version needs to be at least $next_version"
    return 1
  fi
}

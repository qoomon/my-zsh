
function git-repository-version-latest {
  git describe --all --tags --match 'v*' --first-parent --abbrev=0 2>/dev/null| sed 's|^v||'
}

function git-repository-version-bump-recommendation {
  local latest_version=$(git-repository-version-latest)
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

function git-repository-version-next {
  local latest_version=$(git-repository-version-latest)
  local -a latest_version_array; latest_version_array=($(echo "$latest_version" | grep -E -o "[^.-]+" ))
  latest_version_array[4]=$(echo "$latest_version" | sed "s|^[^-]*||" )

  local next_version_bump_recommendation=$(git-repository-version-bump-recommendation)
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

function git-repository-version-compare {
  local current_version=${1:-}
  local -a current_version_array; current_version_array=($(echo "$current_version" | grep -E -o "[^.-]+" ))

  local next_version=$(git-repository-version-next)
  local -a next_version_array; next_version_array=($(echo "$next_version" | grep -E -o "[^.-]+" ))

  if [ ${current_version_array[1]} -lt ${next_version_array[1]} ] \
  || [ ${current_version_array[2]} -lt ${next_version_array[2]} ] \
  || [ ${current_version_array[3]} -lt ${next_version_array[3]} ]; then
    >&2 echo "version needs to be at least $next_version"
    return 1
  fi
}

# fshow - git commit browser (enter for show, ctrl-d for diff, ` toggles sort)
git-browser() {
  local out shas sha q k
  while out=$(
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" --tiebreak=index \
          --print-query --expect=ctrl-d --toggle-sort=\`); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = 'ctrl-d' ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

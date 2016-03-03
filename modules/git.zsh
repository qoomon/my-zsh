# git global config
git config --global merge.ff false
git config --global pull.rebase true
git config --global push.followTags true
git config --global tag.sort version:refname

if type atom >/dev/null; then
  git config --global core.editor "atom --wait"
fi

if type idea >/dev/null; then
  git config --global mergetool.intellij.cmd 'idea merge $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE") $(cd $(dirname "$BASE") && pwd)/$(basename "$BASE") $(cd $(dirname "$MERGED") && pwd)/$(basename "$MERGED")'
  git config --global mergetool.intellij.trustExitCode false
  git config --global merge.tool intellij

  git config --global difftool.intellij.cmd 'idea diff $(cd $(dirname "$LOCAL") && pwd)/$(basename "$LOCAL") $(cd $(dirname "$REMOTE") && pwd)/$(basename "$REMOTE")'
  git config --global difftool.intellij.trustExitCode false
  git config --global diff.tool intellij
fi

alias git_log="git log --graph --all --date=format:'%a %Y-%m-%d %H:%M' --pretty=format:' %C(blue bold)%h%C(reset) %C(white bold)%s%C(reset) %C(dim white)%an%C(reset)%n ↪  %C(dim green)%ar%C(reset) %C(dim cyan)%ad%C(reset)%C(auto)%d%C(reset)'"

alias git_hash='git rev-parse --short HEAD'

# find template in files folder
# git config --global commit.template ~/git_commit_template.txt


# npm install --global commitizen
# npm install --global cz-conventional-changelog
# echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc

# npm install --global conventional-changelog-cli

# npm install --global conventional-recommended-bump

function git_repository_version_latest {
  git describe --all --tags --match 'v*' --first-parent --abbrev=0 | sed 's|^v||'
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
  local current_version=$1
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

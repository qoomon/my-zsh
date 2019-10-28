function git-ssh {
  local privat_key_path="$1"; shift 1
  local git_ssh_command="ssh -i '$privat_key_path' -F /dev/null"
  GIT_SSH_COMMAND=$git_ssh_command git $@
  echo ''
  echo '# configure your git repository to always use this spesific ssh key'
  echo ''
  echo "git config core.sshCommand \"$git_ssh_command\""
}

function git-repository-version-latest {
  git describe --all --tags --match 'v*' --first-parent --abbrev=0 2>/dev/null| sed 's|^v||'
}

# fshow - git commit browser (enter for show, ctrl-d for diff, ` toggles sort)
function git-browser {
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

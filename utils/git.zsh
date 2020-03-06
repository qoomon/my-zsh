function git-ssh {
  local privat_key_path="$1"; shift 1
  # -F /dev/null - disables the use of $HOME/.ssh/config
  # -o IdentitiesOnly=yes - tells SSH to only use keys that are provided via the CLI and none from the $HOME/.ssh or via ssh-agent
  # -i ~/path/to/some_id_rsa - the key that you explicitly want to use for the connection
  local git_ssh_command="ssh -F /dev/null -o IdentitiesOnly=yes -i '$privat_key_path'"
  GIT_SSH_COMMAND=$git_ssh_command git $@
  if [[ $status == 0 ]]
  then
    echo ''
    echo '  INFO: Configure your local repository'
    echo ''
    echo "  git config core.sshCommand \"$git_ssh_command\""
  fi
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
    if [ "$k" = 'ctrl-d' ]
    then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

function jump {
  # check for fzf installed
  if ! type fzf >/dev/null; then
    echo "couldn't find fzf installation" >&2
    return 1
  fi

  local cmd="$1"
  case "$cmd" in
    '..')
      shift;
      local pwd_list=('/' ${(s:/:)PWD%/*})
      local indexed_pwd_list=()
      for pwd_part_index in $(seq 1 ${#pwd_list}); do
          indexed_pwd_list[$pwd_part_index]="$pwd_part_index $pwd_list[$pwd_part_index]"
      done
      local pwd_index="$(printf "%s\n" "${indexed_pwd_list[@]}" | fzf --tac --height 10 --reverse --prompt='  ' --exact --with-nth=2.. | awk '{print $1}')"
      if [ -n "$pwd_index" ]; then
        local dir_list=(${pwd_list:0:$pwd_index})
        local dir="${(j:/:)dir_list}"
        builtin cd "$dir"
      else
        echo "no directory matches" >&2
        return 1
      fi
      ;;
    '.')
      shift;
      local dir_query="$*"
      local dir=$(find . -mindepth 1 \( -type f -o -path '*/.*/*' \) -prune -o -print 2>&1 | sed 's|^\./\(.*\)|\1|' | fzf --tac --height 10 --reverse --prompt='  ' --query "$dir_query" --exact --select-1 --exit-0)
      if [ -n "$dir" ]; then
        builtin cd "$dir"
      else
        echo "no directory matches" >&2
        return 1
      fi
      ;;
    *)
      local dir_query="$@"
      local dir="$(cdr -l | awk '{$1=""; print $0}' | fzf  --height 10 --reverse  --prompt='  ' --query "$dir_query" --exact --select-1 --exit-0)"
      if [ -n "$dir" ]; then
        eval "builtin cd ${dir}"
      else
        echo "no directory matches" >&2
        return 1
      fi
      ;;
  esac
}

#enhanced cd
function jump::cd {
  if [ "$1" = ':' ]; then #  historyfolder selection
    shift
    jump $@
  elif [ "$1" = '...' ]; then # parent folder selection
    shift
    jump .. $@
  elif [ "$1" = '.' ]; then # subfolder selection
    shift
    jump . $@
  else
    builtin cd $@ >/dev/null # suppress stdout
  fi
}

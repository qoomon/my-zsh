function find_ls {

  if [[ "$1" = "--help" ]]; then
    echo "Usage: find_ls find_args [-- ls_args]"
    return
  fi

  function index {
    local index=0;
    for arg in ${@:2}; do
      index=$(expr $index + 1)
      if [[ "$arg" = "$1" ]]; then
        echo $index;
        return
      fi
    done
    echo 0;
  }

  local -a find_args; find_args=($@)
  local -a ls_args

  local ls_args_seperator_index=$(index "--" $@)
  if [ $ls_args_seperator_index -gt 0 ]; then
    find_args=(${@:1:$(expr $ls_args_seperator_index - 1)})
    ls_args=(${@:$(expr $ls_args_seperator_index + 1)})
  fi

  'find' $find_args | while read -r file; do
    if [ "${file}" = "." ]; then
       continue
    fi
    if [[ -d "${file}" ]]; then
      ls $ls_args -d $file
    else
      ls $ls_args $file
    fi
  done
}

function find_contains {
  grep -Ril "$1" $2
}

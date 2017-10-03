function which_ls {

  if [[ "$1" = "--help" ]]; then
    echo "Usage: which_ls which_args [-- ls_args]"
    return
  fi

  function index {
    local index=0;
    for arg in ${@:2}; do
      index=$(($index + 1))
      if [[ "$arg" = "$1" ]]; then
        echo $index;
        return
      fi
    done
    echo 0;
  }

  local -a which_args; which_args=($@)
  local -a ls_args

  local ls_args_seperator_index=$(index "--" $@)
  if [ $ls_args_seperator_index -gt 0 ]; then
    which_args=(${@:1:$(($ls_args_seperator_index - 1))})
    ls_args=(${@:$((ls_args_seperator_index + 1))})
  fi

  ls $ls_args $('which' -p $which_args)
}

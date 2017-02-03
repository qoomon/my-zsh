function alias_colorized {
  if [ $# -gt 0 ] || ! [ -t 1 ]; then # ! [ -t 1 ] is true if piped
    \alias $@
  else
    \alias | grep -v -e '^alias' | sed -E -e "s|^([^ ]*)=(.*)|${fg_bold[blue]}\1 ${fg[white]}###\2$reset_color|" | column -s '###' -t
  fi
}
type compdef >/dev/null && compdef _alias alias_colorized # set default completion
alias alias='alias_colorized'

function which_ls {

  if [[ "$1" = "--help" ]]; then
    echo "Usage: which_ls which_args [-- ls_args]"
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

  local -a which_args; which_args=($@)
  local -a ls_args

  local ls_args_seperator_index=$(index "--" $@)
  if [ $ls_args_seperator_index -gt 0 ]; then
    which_args=(${@:1:$(expr $ls_args_seperator_index - 1)})
    ls_args=(${@:$(expr $ls_args_seperator_index + 1)})
  fi

  ls $ls_args $('which' -p $which_args)
}
function lazyload {
  local load_cmd=$1; shift
  local cmd_list=($@); shift $#

  for cmd_name in $cmd_list; do
    alias $cmd_name="_lazyload '$load_cmd' '${(j:&:)cmd_list}' $cmd_name"
  done
}

function _lazyload {
  local load_cmd=$1; shift
  local load_aliases=(${(s:&:)1}); shift
  local cmd=($@); shift $#

  unalias $load_aliases
  eval "$load_cmd"
  if [[ ${functions[$load_cmd]} ]] && [[ $load_cmd = 'load:'* ]]; then
    unfunction $load_cmd
  fi
  $cmd
}

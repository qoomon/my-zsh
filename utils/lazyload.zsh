function lazyload {
  local load_cmd=$1; shift 1
  local cmd_names=($@)
  for cmd_name in $cmd_names; do
    alias $cmd_name="_lazyload '$load_cmd' $cmd_name $(echo ${cmd_names:#$cmd_name})"
  done
}

function _lazyload {
  local load_cmd=$1; shift 1
  local cmd=$1
  local cmd_alias=($@)
  unalias $cmd_alias
  eval "$load_cmd"
  if [[ ${functions[$load_cmd]} ]] && [[ $load_cmd = 'load:'* ]]; then
    unfunction $load_cmd
  fi
  $cmd
}
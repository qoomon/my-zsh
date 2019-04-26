function lazyload {
  local load_cmd=$1; shift
  local cmd_list=($@); shift $#

  for cmd_name in $cmd_list; do
    alias $cmd_name="unalias ${cmd_list}; $load_cmd; $cmd_name"
  done
}

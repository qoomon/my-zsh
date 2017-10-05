function ssh_tunnel {
  
  local local_port=$1
  local remote_host=$2
  local remote_target_host=$3

  ssh -N -L "$local_port":"$remote_target_host" "$remote_host"
}

function ssh_jump {
  local jump_host=$1
  local target_host=$2
  ssh -o ProxyCommand="ssh -W %h:%p '$jump_host'"  "$target_host"
}

function ssh_key_set {
   ssh-add -D
   ssh-add "$HOME/.ssh/${1:-id_rsa}"
}

function ssh_key_info {
   ssh-keygen -l -f "$HOME/.ssh/${1:-id_rsa}"
}


# ~/.ssh/config
######
# Host *
#   IdentityFile ~/.ssh/id_rsa+%r@%h
# Host *
#   IdentityFile ~/.ssh/id_rsa
######
#
# e.g. ~/.ssh/id_rsa+<REMOTE_USER>@<REMOTE_HOST>
#
# ln -s <KEY_NAME>.pub <TARGET_KEY_NAME>.pub
# ln -s <KEY_NAME>     <TARGET_KEY_NAME>

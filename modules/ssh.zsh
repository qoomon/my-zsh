function ssh_tunnel {

  local remote_host=$1
  local remote_port=$2
  local local_port=$3

  ssh -L ${local_port}:localhost:${remote_port} ${remote_host}
}

function ssh_key_set {
   ssh-add -D
   ssh-add "$HOME/.ssh/${1:-id_rsa}"
}

function ssh_key_info {
   ssh-keygen -l -f "$HOME/.ssh/$1"
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

function ssh-tunnel {
  
  local local_port=$1
  local remote_host=$2
  local remote_target_host=$3

  ssh -N -L "$local_port":"$remote_target_host" "$remote_host"
}

# ssh_jump 'root@example.org' -p 22 -- "root@example.com" -p 2222
function ssh-jump {
  local split_index=${@[(ie)--]}
  local proxy_paramters=(${@:1:$((split_index-1))})
  local target_paramters=(${@:$((split_index+1))})
  ssh -o ProxyCommand="ssh -W %h:%p $proxy_paramters" $target_paramters
}
#ssh -o ProxyCommand="ssh -W %h:%p 'root@example.org'" "root@example.com" -p 2222

function ssh-key-set {
   ssh-add -D
   ssh-add "$HOME/.ssh/${1:-id_rsa}"
}

function ssh-key-info {
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

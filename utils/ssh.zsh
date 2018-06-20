function ssh-key-set {
   ssh-add -D
   ssh-add "$HOME/.ssh/${1:-id_rsa}"
}

function ssh-key-info {
   ssh-keygen -l -f "$HOME/.ssh/${1:-id_rsa}"
}


autoload +X -U colors && colors
function ssh-examples {
  echo " ${fg_bold[magenta]}-${reset_color} ${fg_bold[yellow]}Tunneling${reset_color}"
  echo "     ${fg_bold[green]}ssh${reset_color} ${fg_bold[blue]}username${reset_color}@${fg_bold[blue]}target_host${reset_color} -L ${fg_bold[blue]}tunnelport${reset_color}:${fg_bold[blue]}remote_host${reset_color}:${fg_bold[blue]}remote_port${reset_color} -N"
  
  echo " ${fg_bold[magenta]}-${reset_color} ${fg_bold[yellow]}Jumping${reset_color}"
  echo "     ${fg_bold[green]}ssh${reset_color} -J ${fg_bold[blue]}username${reset_color}@${fg_bold[blue]}jump_host${reset_color} ${fg_bold[blue]}username${reset_color}@${fg_bold[blue]}target_host${reset_color}"
}

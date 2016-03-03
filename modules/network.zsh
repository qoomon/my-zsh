function ip_internal {
  if [ -n "$1" ]; then
    local interface=$1
    local ip=$(ipconfig getifaddr $interface)
    if [ $? -eq 0 ]; then
      echo $ip
    else
      return 1
    fi
  else
    local -a interface_list; interface_list=($(ifconfig -l))
    for interface in $interface_list; do
        ip=$(ipconfig getifaddr $interface)
        if [ -n "$ip" ]; then
          echo "$interface: $ip"
        fi
    done
  fi
}

function ip_external {
  curl ifconfig.co
}

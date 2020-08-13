function spoof-mac-address {
  local new_mac_address="$(openssl rand -hex 6 | sed 's/../&:/g; s/:$//')"
  sudo ifconfig "${1:-en0}" ether "${new_mac_address}"
  echo -n 'new mac address: '
  ifconfig "${1:-en0}" | grep ether | cut -d" " -f2
}

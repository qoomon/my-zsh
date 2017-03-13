function gauth {
  local secretBase32=$1
  watch -n1 'echo $(oathtool --totp --base32 '$secretBase32') $(expr 30 - $(date +%s) % 30)s'
}

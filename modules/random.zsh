function random_character {
  local character_count=${1:-32}
  cat /dev/urandom | base64 | head -c $character_count
}
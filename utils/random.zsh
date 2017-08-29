function random {
  local character_count=${1:-32}
  local character_set=${2:-'A-Za-z0-9!#$%&()*+,-./:;<=>?@[]^_`{|}~'}
  head /dev/urandom | LC_ALL=C tr -dc ${character_set} | head -c ${character_count}
}
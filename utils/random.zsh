function random_character {
  local character_count=${1:-32}
  cat /dev/urandom | base64 | head -c $character_count
}

function random_number {
  local number_count=${1:-32}
  local number=''
  
  while [ ${#number} -lt $number_count ]; do
    number+=$RANDOM
  done
  
  echo -n ${number:0:$number_count}
}
function random_character {
  local character_count=${1:-32}
  cat /dev/urandom | base64 | head -c $character_count
}

function random_number {
  local number_count=${1:-32}
  local number=''
  for index in $(seq 1 $number_count); do 
    local random=$RANDOM
    number="${number}$(expr $random % 10 )"
  done
  echo $number
}
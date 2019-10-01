autoload +X -U colors && colors

function hibp {
  local password
  if [[ -t 0 ]]; then
    echo -n 'Password:'
    read -s password
    echo -en "\r\033[K"
  else
    read -s password
  fi
  
  local password_sha1="$(echo -n $password | shasum | cut -d' ' -f1 | tr a-z A-Z)"
  if (curl -s "https://api.pwnedpasswords.com/range/${password_sha1:0:5}" \
      | grep -q "${password_sha1:5}"); then
    echo "${fg_bold[red]}Oh no — pwned!${reset_color}"
    return 0
  else
    echo "${fg_bold[green]}Good news — no pwnage found!${reset_color}"
    return 1
  fi
}

function hibp_clipperz {
  local clipperz_export_file="$1"
  local card field secret
  xmllint --xpath 'string(/html/body/div/div/textarea)' "$clipperz_export_file" \
  | jq '.[] | . as $card | .currentVersion.fields[] | select(.hidden) | [$card.label,.label,.value] | @tsv' -r \
  | grep -v 'ARCH' \
  | while IFS=$'\t' read card field secret; do
      if [[ "${field:l}" =~ (code|pin|cvc|cvv) ]] \
          && [[ "${#secret}" -le 6 ]] \
          && [[ "${#secret}" =~ ^[0-9]*$ ]] &&; then
        continue
      fi
      
      card="${card%% *}"
      echo -n "${fg_bold[yellow]}Check...${reset_color}         =>    ${fg[cyan]}${card}${reset_color}   >   ${fg[blue]}${field}${reset_color}"
      pwned='no' && echo -n "$secret" | hibp >/dev/null && pwned='yes'
      echo -en "\r\033[K"
      if [[ "$pwned" == 'yes' ]]; then
        echo "${fg_bold[red]}Oh no — pwned!${reset_color}   =>    ${fg[cyan]}${card}${reset_color}   >   ${fg[blue]}${field}${reset_color}"
      fi
  done
}
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
  if (curl -Ns "https://api.pwnedpasswords.com/range/${password_sha1:0:5}" \
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
      if [[ "${secret}" == "" ]] ; then
        continue
      fi

      if [[ "${field:l}" =~ (code|pin|cvc|cvv) ]] \
          && [[ "${#secret}" =~ ^[0-9]{0,6}$ ]] &&; then
        continue
      fi

      (
        card="${card%% *}"
        echo -n "${fg_bold[yellow]}Check...${reset_color}         =>    ${fg[cyan]}${card}${reset_color}   >   ${fg[blue]}${field}${reset_color}"
        pwned='no' && echo -n "$secret" | hibp >/dev/null && pwned='yes'
        test $? -gt 128 && break
        echo -en "\r\033[K"
        if [[ "$pwned" == 'yes' ]]; then
          echo "${fg_bold[red]}Oh no — pwned!${reset_color}   =>    ${fg[cyan]}${card}${reset_color}   >   ${fg[blue]}${field}${reset_color}"
        fi
      ) || break
  done
}



function hibp_chrome {
  local chrome_export_file="$1"
  local card field secret
  tail -n +2 "$chrome_export_file" \
  | while IFS=$',' read name url username password; do
      if [[ "${password}" == "" ]] ; then
        continue
      fi

      # if [[ "${#password}" =~ ^[0-9]{0,6}$ ]] &&; then
      #   continue
      # fi

      (
        echo -n "${fg_bold[yellow]}Check...${reset_color}         =>    ${fg[cyan]}${name}${reset_color}   >   ${fg[blue]}${username}${reset_color}"
        pwned='no' && echo -n "$password" | hibp >/dev/null && pwned='yes'
        echo -en "\r\033[K"
        if [[ "$pwned" == 'yes' ]]; then
          echo "${fg_bold[red]}Oh no — pwned!${reset_color}   =>    ${fg[cyan]}${name}(${url})${reset_color}   >   ${fg[blue]}${username}${reset_color}"
        fi
      ) || break
  done
}

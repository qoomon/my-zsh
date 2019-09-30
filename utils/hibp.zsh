function hibp {
  read -rs PASSWORD
  PASSWORD_SHA1="$(echo -n $PASSWORD | shasum | cut -d' ' -f1 | tr a-z A-Z)"
  if (curl -s "https://api.pwnedpasswords.com/range/${PASSWORD_SHA1:0:5}" | grep "${PASSWORD_SHA1:5}" >/dev/null)
  then
    echo 'Oh no — pwned!'
  else
    echo 'Good news — no pwnage found!'
  fi
}
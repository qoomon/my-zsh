function openssl-download-certificate {
  local host=$1
  local port=${2:-443}
  openssl s_client -showcerts -connect "${host}:${port}" </dev/null 2>/dev/null | openssl 'x509' -outform 'PEM' > "${host}:${port}.pem"
}

## generate fingerprint from certificate
# openssl x509 -in certificate.crt -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64

## generate selfsigned certificate for localhost
 openssl req -x509 -out localhost.crt -keyout localhost.key \
   -newkey rsa:4096 -nodes -sha256 \
   -subj '/CN=localhost' -extensions EXT -config <( \
    printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")


autoload +X -U colors && colors
function ssl-examples {
  echo " ${fg_bold[magenta]}-${reset_color} ${fg_bold[yellow]}Generate fingerprint from certificate${reset_color}"
  echo "     ${fg_bold[green]}openssl${reset_color} x509 -in ${fg_bold[blue]}certificate.crt${reset_color} -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64"
  
  echo " ${fg_bold[magenta]}-${reset_color} ${fg_bold[yellow]}Generate selfsigned certificate for localhost${reset_color}"
  echo "     ${fg_bold[green]}openssl${reset_color} req -x509 -out localhost.crt -keyout localhost.key -newkey rsa:4096 -nodes -sha256 -subj '/CN=localhost' -extensions EXT -config <(printf '[dn]\\\nCN=localhost\\\n[req]\\\ndistinguished_name = dn\\\n[EXT]\\\nsubjectAltName=DNS:localhost\\\nkeyUsage=digitalSignature\\\nextendedKeyUsage=serverAuth')"
}
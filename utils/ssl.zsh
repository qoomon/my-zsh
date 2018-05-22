function openssl-download-certificate {
  local host=$1
  local port=${2:-443}
  openssl s_client -showcerts -connect "${host}:${port}" </dev/null 2>/dev/null | openssl 'x509' -outform 'PEM' > "${host}:${port}.pem"
}

# generate fingerprint from certificate
#openssl x509 -in certificate.crt -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64

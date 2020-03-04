# Get Certificate Fingerprint
```shell
openssl x509 -in certificate.crt -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```

# Generate Self-Signed Certificate For Localhost
```shell
openssl req -x509 \
  -newkey rsa:4096 -nodes -sha256 \
  -days 36500 \
  -out localhost.crt \
  -keyout localhost.key \
  -subj '/CN=localhost' \
  -extensions EXT \
  -config <( \
  printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
```

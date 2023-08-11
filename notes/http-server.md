# Start an HTTP Server
`python3 -m http.server 8080`

### create reverse tunnel
`ssh -R 80:localhost:8080 nokey@localhost.run`
`ssh -R 80:localhost:8080 serveo.net`


# Start an HTTPS Server
```shell
npm install --global http-server
sudo http-server -a localhot -p 8443 --ssl --cert localhost.crt --key localhost.key
```

### Generate Self-Signed Certificate For Localhost
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

### Add certificate to Keychain as Trusted Root Certificate
##### macOS
```shell
sudo security -v add-trusted-cert -r trustRoot -d -k '/Library/Keychains/System.keychain' localhost.crt
```

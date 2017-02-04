# --- setup
# npm install --global http-server

# --- ssl setup
# sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" $ZSH_FILE_DIR/localhost.pem
#
# --- add folowing to /etc/hosts
# 127.0.0.1	local.host
# ::1             local.host

# --- convert pem to jks
# pem_file="localhost.pem"
# keystore_password='password'
# openssl pkcs12 -export -out keystore.p12 -passout pass:"$keystore_password" -inkey $pem_file -in $pem_file -passin pass:"$keystore_password"
# keytool -importkeystore -destkeystore keystore.jks -deststorepass "$keystore_password" -srcstoretype PKCS12 -srckeystore keystore.p12 -srcstorepass "$keystore_password"
# keytool -list -keystore keystore.jks -storepass "$keystore_password"

# brew install dnsmasq --- e.g. wildcard dns server *.localhost

# install OSX: sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.ssl/localhost.pem

alias http-server='command http-server -p 8080 -o'
# alias http_server='docker run --name my-nginx -p 80:80 -v $PWD:/usr/share/nginx/html:ro --rm nginx'
alias http-server-ssl="command http-server -p 8443 -o --ssl --cert $ZSH_FILE_DIR/localhost.pem --key $ZSH_FILE_DIR/localhost.pem"
alias https-server='http-server-ssl'

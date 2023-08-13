
ln -rs /etc/pki/tls/openssl.cnf /etc/ssl/openssl.cnf

# Generate CA Certificate
openssl genpkey -algorithm RSA -out ca.key
openssl req -new -key ca.key -out ca.csr -subj "/CN=paulpranshu.xyz"
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt -days 365

# Generate Dovecot Private Key and CSR
openssl req -new -newkey rsa:4096 -nodes -keyout dovecot.key -out dovecot.csr -subj "/CN=paulpranshu.xyz"

# Sign Dovecot Certificate with CA
openssl x509 -req -in dovecot.csr -out dovecot.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 365


# Generating DKIM record to digital sign emails.
openssl genpkey -algorithm RSA -out dkim_private.key
openssl rsa -in dkim_private.key -pubout -out dkim_public.key


openssl s_client -connect paulpranshu.xyz:25




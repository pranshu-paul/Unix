# post-gresql.conf
# ssl_ca_file
# pg_hba.conf
# clientcert=verify-ca
# clientcert=verify-full

ln -rs /etc/pki/tls/openssl.cnf /etc/ssl/openssl.cnf

# openssl req -new -x509 -days 365 -nodes -text -out server.crt \
# -keyout server.key -subj "/CN=el8.paulpranshu.xyz"

# Create a root certificate key and signing request.
openssl req -new -nodes -text -out root.csr \
-keyout root.key -subj "/CN=el8.paulpranshu.xyz"

# Sign the root certificate.
openssl x509 -req -in root.csr -text -days 3650 \
-extfile /etc/ssl/openssl.cnf -extensions v3_ca \
-signkey root.key -out root.crt

# Create a server key and certificate signing request.
openssl req -new -nodes -text -out server.csr \
-keyout server.key -subj "/CN=el8.paulpranshu.xyz"

chmod 400 server.key
chmod 400 server.key

# Sign the server's signing request from the root certificate's private key.
openssl x509 -req -in server.csr -text -days 365 \
-CA root.crt -CAkey root.key -CAcreateserial \
-out server.crt

# Default location where postgresql looks for the certifcate and keys.
echo $PGDATA/server.crt
echo $PGDATA/server.key

# Add the location of the certifcate and key in the file "/var/lib/pgsql/data/postgresql.conf"
# Enable SSL
ssl = on
ssl_cert_file = '/var/lib/pgsql/server.crt'
ssl_key_file = '/var/lib/pgsql/server.key'

vim /var/lib/pgsql/data/pg_hba.conf

# TYPE  DATABASE        USER            ADDRESS                 METHOD
hostssl  all             all             0.0.0.0/0               md5

# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                md5


pg_ctl reload

psql "sslmode=require dbname=students user=postgres host=127.0.0.1"

# Open Secure Sockets Layer


# To check openssl's version.
openssl version

# To list the default Public Key Infrastructure directory.
openssl version -d

# Custom CA directory.
/etc/pki/ca-trust/source/anchors

# Generate a random password.
openssl rand -base64 12


## The below steps works properly. ##

# Create a password protected private key, to be used to create the Root Certificate.
# Create a self-signed root certificate.
# For testing password must be: root@123
openssl genpkey -algorithm RSA -aes256 -out root-ca-key.pem -pkeyopt rsa_keygen_bits:4096
openssl req -new -x509 -sha256 -days 3650 -key root-ca-key.pem -out root-ca-cert.pem -subj "/CN=Pranshu Root CA"

# Generate a csr.
openssl genpkey -algorithm RSA -out server-key.pem
openssl req -new -sha256 -subj "/CN=esxi01" -key server-key.pem -out server.csr

# Generate a self-signed certifcate.
# "subjectAltName=DNS:paulpranshu.xyz,IP:144.24.111.213"
openssl x509 -req -sha256 -days 365 -in server.csr -CA root-ca-cert.pem -CAkey root-ca-key.pem -out server.pem -extfile <(printf "subjectAltName=IP:10.0.1.8") -CAcreateserial

# Verify the certifcate.
openssl verify -CAfile root-ca-cert.pem -verbose server.pem

# List the root CA cert.
ls -l root-ca-cert.pem

# Update the local public key infrastructure.
cp -v root-ca-cert.pem /etc/pki/ca-trust/source/anchors/root-ca-cert.pem
update-ca-trust

# Import the root certifcate in windows as well.
# Import-Certificate -FilePath "root-ca-cert.pem" -CertStoreLocation Cert:\LocalMachine\Root

##																	##

# To verify.
openssl s_client -connect 10.0.1.8:443

# Copy the root certifcate to the OS PKI.
update-ca-trust enable
cp -v root-ca-cert.pem /etc/pki/ca-trust/source/anchors
update-ca-trust extract

# To import the certifcate in windows.
Import-Certificate -FilePath "root-ca-cert.pem" -CertStoreLocation Cert:\LocalMachine\Root



# Certificate validation command.
openssl x509 -text -noout -in certificate.crt

# Private key validation command.
openssl rsa -check -in privatekey.key


# Command to verify the pair of certifcate and key.
openssl x509 -noout -modulus -in certificate.crt | openssl md5
openssl rsa -noout -modulus -in privatekey.key | openssl md5

# To encrypt a file.
openssl enc -e -aes-256-cbc \
-salt \
-pbkdf2 \
-iter 1000000 \
-md sha512 \
-base64 \
-in <file_to_encrypt> \
-out <output_name>.enc

# To decrypt a file.
openssl enc -d -aes-256-cbc \
-salt \
-pbkdf2 \
-iter 1000000 \
-md sha512 \
-base64 \
-in <file_to_decrypt>.enc \
-out <output_name> 

# To encrypt a file.
openssl enc -aes-256-cbc -pbkdf2 -in backup-copy -out backup-copy.enc

# To decrypt a file.
openssl enc -d -aes-256-cbc -pbkdf2 -in backup-copy.enc -out /dev/stdout -pass file:<(echo -n "windows")

# To get the provider of the cert
openssl s_client -connect smtp.email.us-ashburn-1.oci.oraclecloud.com:587 -starttls smtp

# Glossary:
# Asymmetric Encryption

# Certificate: public key
# Private Key: private key
# CA: A CA certifies the key exchange between two nodes.

# Root certificate (Public key) is installed on the client side.


# TLS Handshake:

# Client inititiates the connection with its certifcate (public key)
# Server replies with its certifcate (public key).
# CA certificate installed at client's verifies the server's certifcate.

# Client generates a random session key for symmetric encryption and encrypts using the servers public key.
# Server decrypts it and use it for the rest of the connection.


# To generate an RSA key pair.
openssl genrsa -out private.pem 4096

# To generate a public key for the private key.
openssl rsa -in private.pem -pubout -out public.pem


#######################################################

# The below steps are with an intermediate certificate.
# Creating a Root Certificate.

# Create a password protected private key, to be used to create the Root Certificate.
# Create a self-signed root certificate.
# subj "/C=IN/ST=Delhi/L=Delhi/O=Paul IT Labs/OU=Home Labs/CN=Paul Root CA"
openssl genpkey -algorithm RSA -aes256 -out root-ca-key.pem -pkeyopt rsa_keygen_bits:4096
openssl req -new -x509 -sha256 -days 3650 -key root-ca-key.pem -out root-ca-cert.pem -subj "/CN=Root CA"


# Creating an intermediate certificate.

# Create a private key for the intermediate certificate.
openssl genpkey -algorithm RSA -aes256 -out intermediate-ca-key.pem -pkeyopt rsa_keygen_bits:2048

# Create a Certificate Signing Request for the intermediate certificate.
openssl req -new -key intermediate-ca-key.pem -out intermediate.csr -subj "/CN=paulpranshu.xyz"

# Create the intermediate certificate from the CSR, root certificate, and root certificate key.
# An intermediate certificate and root serial number will be generated.
openssl x509 -req -in intermediate.csr -CA root-ca-cert.pem -CAkey root-ca-key.pem -CAcreateserial -out intermediate-crt.pem -days 1825


# Generate a csr
openssl genpkey -algorithm RSA -out server-key.pem
openssl req -new -sha256 -subj "/CN=paulpranshu.xyz" -key server-key.pem -out server.csr

# Generate a self-signed certifcate.
# "subjectAltName=DNS:paulpranshu.xyz,IP:144.24.111.213"
openssl x509 -req -sha256 -days 365 -in server.csr -CA intermediate-crt.pem -CAkey intermediate-ca-key.pem -out server.pem \
-extfile <(printf "subjectAltName=DNS:paulpranshu.xyz,IP:144.24.111.213") -CAcreateserial

# To create the bundle certificate as the server certificate.
cat intermediate-crt.pem server.pem > bundle.pem

# To create a bundle root certificate.
cat root-ca-cert.pem intermediate-crt.pem > root-bundle.pem


# Signing Java JAR files.
# Required JDK devel package.

# Install Open JDK Devel Package.
dnf -yq install java-1.8.0-openjdk-devel

# Download a sample JAR file.
curl -O https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar

# Verify whether the JAR is signed.
jarsigner -verify commons-lang3-3.12.0.jar

# Create Java keystore with a password.
keytool -genkeypair -alias mykey -keyalg RSA -keysize 2048 -validity 365 -keystore mykeystore.jks

# Sign the JAR file.
jarsigner -keystore mykeystore.jks commons-lang3-3.12.0.jar mykey

# Verify the signature.
jarsigner -verify commons-lang3-3.12.0.jar


## Another approach for the same.

# Create a Root CA
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout rootCA.key -out rootCA.crt \
  -subj "/C=IN/ST=Delhi/L=Delhi/O=Paul IT Labs/OU=Home Labs/CN=Paul Root CA"
  
# Generate Key Pair and Keystore
keytool -genkeypair -alias jar-signer \
  -keyalg RSA -keysize 2048 -keystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts \
  -dname "CN=Pranshu, OU=Home Labs, O=Paul IT Labs, L=Delhi, ST=Delhi, C=IN" \
  -validity 365

# Generate a Certificate Signing Request
keytool -certreq -alias jar-signer \
  -keystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts \
  -file jar-signer.csr
  
# Sign the CSR Using the Root CA
openssl x509 -req -in jar-signer.csr -CA rootCA.crt -CAkey rootCA.key \
  -CAcreateserial -out jar-signer.crt -days 365 -sha256
  
# Import Root CA into the Keystore (as Trusted Certificate) in the default root CA.
# For the below command the default passowrd: changeit
keytool -import -trustcacerts -alias rootca   \
-file rootCA.crt   \
-keystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts

# Import the Signed Certificate into the Default Keystore
# Default password: changeit
keytool -import -alias jar-signer \
  -file jar-signer.crt \
  -keystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts
  
# Sign the JAR File and use a Public TSA
jarsigner -keystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts \
-tsa http://timestamp.digicert.com ../commons-lang3-3.12.0.jar jar-signer

# Verify
jarsigner -verify -keystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts  \
-certs ../commons-lang3-3.12.0.jar


# Import Java keystore in pkcs12 format.
keytool -importkeystore \
  -srckeystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts \
  -destkeystore /etc/java/java-1.8.0-openjdk/java-1.8.0-openjdk-1.8.0.402.b06-2.el8.x86_64/lib/security/cacerts \
  -deststoretype pkcs12
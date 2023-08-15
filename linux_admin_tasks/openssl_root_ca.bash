# Open Secure Sockets Layer


# To check openssl's version.
openssl version

# To list the default Public Key Infrastructure directory.
openssl version -d

# Custom CA directory.
/etc/pki/ca-trust/source/anchors

ln -rs /etc/pki/tls/openssl.cnf /etc/ssl/openssl.cnf

# Generate a random password.
openssl rand -base64 12


# Creating a Root Certificate.

# Create a password protected private key, to be used to create the Root Certificate.
openssl genpkey -algorithm RSA -aes256 -out root-ca-key.pem -pkeyopt rsa_keygen_bits:4096

# Create a self-signed root certificate.
openssl req -new -x509 -sha256 -days 3650 -key root-ca-key.pem -out root-ca-cert.pem -subj "/CN=Root CA"



# Creating an intermediate certificate.

# Create a private key for the intermediate certificate.
openssl genpkey -algorithm RSA -aes256 -out intermediate-ca-key.pem -pkeyopt rsa_keygen_bits:2048

# Create a Certificate Signing Request for the intermediate certificate.
openssl req -new -key intermediate-ca-key.pem -out intermediate.csr -subj "/CN=Intermediate CA"

# Create the intermediate certificate from the CSR, root certificate, and root certificate key.
# An intermediate certificate and root serial number will be generated.
openssl x509 -req -in intermediate.csr -CA root-ca-cert.pem -CAkey root-ca-key.pem -CAcreateserial -out intermediate-crt.pem -days 1825



# Creating the server certificate and key.
openssl genpkey -algorithm RSA -out server-key.pem

# Create a Certificate Signing Request for the server certificate.
# /C=IN/ST=Delhi/L=Delhi/O=OSWebAdmin/OU=Linux administration/CN=*.oswebadmin.com
openssl req -new -key server-key.pem -out server.csr -subj "/CN=paulpranshu.xyz"

# Create a self-signed certifcate by signing the server.csr.
openssl x509 -req -in server.csr -CA intermediate-crt.pem -CAkey intermediate-ca-key.pem -CAcreateserial -out server-crt.pem -days 365

# To verify.
openssl s_client -connect paulpranshu.xyz:25

# Copy the root certifcate to the OS PKI.
update-ca-trust enable
cp -v root-ca-cert.pem /etc/pki/ca-trust/source/anchors
update-ca-trust extract

# To import the certifcate in windows.
Import-Certificate -FilePath "root-ca-cert.pem" -CertStoreLocation Cert:\LocalMachine\Root








#######################################################
#The below steps works properly.
# Password: windows


# Generate Root key and Cert.
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -sha256 -days 365 -key ca-key.pem -out ca.pem

# Generate a csr
openssl genrsa -out cert-key.pem 4096
openssl req -new -sha256 -subj "/CN=paulpranshu.xyz" -key cert-key.pem -out cert.csr

echo "subjectAltName=DNS:paulpranshu.xyz,IP:144.24.111.213" >> extfile.cnf

# Generate a self-signed certifcate.
openssl x509 -req -sha256 -days 365 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial

# Verify the certifcate.
openssl verify -CAfile ca.pem -verbose cert.pem

# Update the local public key infrastructure.
cp -v ca.pem /etc/pki/ca-trust/source/anchors/ca.pem
update-ca-trust

# Import the root certifcate in windows as well.
# Import-Certificate -FilePath "C:\ca.pem" -CertStoreLocation Cert:\LocalMachine\Root



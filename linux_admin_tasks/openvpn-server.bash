# Set the system timezone to Asia/Kolkata (adjust according to your region if necessary).
timedatectl set-timezone Asia/Kolkata

# Register the system with Red Hat subscription service.
subscription-manager register

# Install essential utilities: bash-completion, vim, and firewalld for firewall management.
dnf -y install bash-completion vim

# Update the system with minimal security updates.
dnf -y update-minimal --security

# Reboot the system to apply security updates.
shutdown -r now

# Update the Red Hat release packages.
dnf -y update redhat-release redhat-release-eula

# Configure SSH to listen on a custom port (2169 in this case) and open the port in the firewall.
semanage port -a -t ssh_port_t -p tcp 2169
firewall-offline-cmd --add-port=2169/tcp

# Enable and start firewalld, which manages firewall rules.
systemctl enable --now firewalld

# Reload the SSH service to apply the new port configuration.
systemctl reload sshd

# Install the EPEL repository to access additional software packages.
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

# Enable the CRB repository
/usr/bin/crb enable

# Install OpenVPN and Easy-RSA.
# Easy-RSA is used to generate cryptographic keys and certificates
dnf -y install openvpn easy-rsa bc

# Check whether openvpn supports dynamic loading of shared objects.
# If not, MFA won't work.
openvpn --version | grep enable_pam_dlopen

# Create a directory for Easy-RSA configuration files.
mkdir -p /ca

# Copy the Easy-RSA scripts and configuration files into the new directory.
# These files will help generate and manage the cryptographic keys and certificates.
cp -rv /usr/share/easy-rsa/3/* /ca

# Initialize the Public Key Infrastructure (PKI).
# This step creates the directory structure needed for managing certificates and keys.
env -C /ca /ca/easyrsa init-pki

# Build the Certificate Authority (CA), which signs the server and client certificates.
# The CA is the trusted authority that ensures certificates are valid.
# Password: root@678
env -C /ca /ca/easyrsa build-ca

# Generate a private key and certificate request for the server.
# The server's private key and certificate are used to authenticate the server to clients.
env -C /ca /ca/easyrsa gen-req server nopass

# Sign the server certificate request with the CA.
# This ensures that the server's identity is validated by the CA, enabling trust between clients and the server.
env -C /ca /ca/easyrsa sign-req server server

# Generate Diffie-Hellman (DH) parameters for secure key exchange.
# DH ensures that keys exchanged between the server and client are securely negotiated.
env -C /ca /ca/easyrsa gen-dh

# Generate a private key and certificate request for the client.
# Each client connecting to the VPN requires its own key and certificate for authentication.
env -C /ca /ca/easyrsa gen-req <client_cert_name> nopass
env -C /ca /ca/easyrsa gen-req client nopass

env -C /ca /ca/easyrsa sign-req client <client_cert_name>
env -C /ca /ca/easyrsa sign-req client client

/u01/easy-rsa/easyrsa --vars=/u01/easy-rsa/pki/vars gen-req client02 nopass
/u01/easy-rsa/easyrsa --vars=/u01/easy-rsa/pki/vars sign-req client client02

# Generate a static key for TLS authentication.
# TLS authentication adds an additional layer of security to prevent unauthorized connections.
openvpn --genkey secret /etc/openvpn/ta.key

# Copy the necessary certificates and keys to the OpenVPN configuration directory.
# These files are essential for the server to authenticate itself and encrypt the traffic between clients and the server.
env -C /ca cp -v pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem /etc/openvpn

# Create a directory for openpvn 
mkdir -p /u01/openvpn

# Chnage ownership and set SELinux var_log label.
chown openvpn:openvpn /u01/openvpn
semanage fcontext -a -t openvpn_var_log_t '/u01/openvpn'
restorecon -Rrv openvpn

# Open the OpenVPN server configuration file for editing.
vim /etc/openvpn/server/server.conf

# Example OpenVPN Server Configuration

port 1194                         # OpenVPN listens on port 1194
proto udp4                         # Use UDP as the transport protocol (Layer 4, Transport Layer).
dev tun                            # Use a TUN device (Layer 3, Network Layer) to route IP packets through the VPN
tls-server                         # Enable TLS to secure connections (Layer 5, Session Layer;
ca /etc/openvpn/ca.crt             # Path to the Certificate Authority (CA) certificate
cert /etc/openvpn/server.crt       # Path to the server's signed certificate
key /etc/openvpn/server.key        # Path to the server's private key 
dh /etc/openvpn/dh.pem             # Path to the Diffie-Hellman parameters
tls-crypt /etc/openvpn/ta.key      # Path to the TLS key for added security
auth SHA256                        # Use SHA256 for HMAC authentication
tun-mtu 1500                       # Set the MTU size for the TUN interface (Layer 3, Network Layer)
topology subnet                    # Use subnet topology (Layer 3, Network Layer)
server 10.0.7.0 255.255.255.0      # Define the internal VPN network (Layer 3, Network Layer)
keepalive 10 120                   # Ping clients every 10 seconds and disconnect after 120 seconds (Layer 5, Session Layer)
push "redirect-gateway def1"       # Redirect all client traffic through the VPN (Layer 3, Network Layer)
push "dhcp-option DNS 8.8.8.8"     # Push Google DNS to clients (Layer 3, Network Layer)
push "dhcp-option DNS 8.8.4.4"
data-ciphers AES-256-GCM:AES-128-GCM
data-ciphers-fallback AES-256-CBC                 # Use AES-256 encryption (Layer 5, Session Layer)
status /u01/openvpn/openvpn-status.log          # Output VPN server status
verb 3                             # Set verbosity level for logging

# Enable IP forwarding on the server to allow traffic between VPN clients and the external network.
# This ensures that traffic can flow between VPN clients and external resources (Layer 3, Network Layer).
vim /etc/sysctl.conf
net.ipv4.ip_forward=1              # Enable IPv4 forwarding (Layer 3, Network Layer)
net.ipv6.conf.all.forwarding=1     # Enable IPv6 forwarding (Layer 3, Network Layer)

# Apply the IP forwarding settings.
sysctl --system

# Open the firewall for OpenVPN traffic on port 1194 (UDP).
# This allows clients to connect to the VPN server on the specified port.
firewall-cmd --add-port=1194/udp

# Enable IP masquerading (NAT) to allow VPN clients to access the internet.
# IP masquerading allows internal client traffic to be translated to the server's public IP for internet access.
firewall-cmd --add-masquerade

# Make firewall rules persistent across reboots.
firewall-cmd --runtime-to-permanent

# Enable and start the daemon.
systemctl enable openvpn@server.service
systemctl start openvpn-server@server.service

# Start the OpenVPN server using the configuration file.
# This will begin listening for client connections and route traffic securely through the VPN.
nohup openvpn /etc/openvpn/server/server.conf &

# Setting up log rotation.

vim /etc/logrotate.d/openvpn

/u01/openvpn/*.log {
    weekly
    missingok
    rotate 4
    compress
    delaycompress
    notifempty
    create 640 openvpn openvpn
    sharedscripts

    postrotate
        systemctl reload openvpn-server@server.service > /dev/null 2>&1 || true
    endscript
}

# Test the configuration
logrotate --force /etc/logrotate.d/openvpn

# Use client side.
tail -f /var/log/secure

### Client side ###
vim client.opvn


client
dev tun
proto udp4
remote 139.59.87.104 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
tun-mtu 1500
verb 3
tls-client

<ca>
-----BEGIN CERTIFICATE-----
MIIDPzCCAiegAwIBAgIUbvSXSFSeb9MJFutHwKuT6310+dcwDQYJKoZIhvcNAQEL
BQAwEjEQMA4GA1UEAwwHb3BlbnZwbjAeFw0yNTA3MDgwNzMyMTZaFw0zNTA3MDYw
NzMyMTZaMBIxEDAOBgNVBAMMB29wZW52cG4wggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQCrsMXwr0lNRAjnFJcjd2DHnAK2Xsb2A6oLLxkBBOaoQ1djO8xE
NZk+bzrnOdGHIWMXzYgZoz8H1f7H2+MsPBVL33gJ4+sgRdZe6qCS4te/+xgv+jGG
VYlupHOVhmorT0mAHhG9beLYWcH8tGDGYH4nzZIOG3/R6PQRcKHMwyhe0+qV6qWp
T6Aon9MG7JGVaB2XtjhOM6KXnsvr/pTGIQdSLhnnBgC06MZ2g+atEAo2SvNHDic/
FAwetK+jA2G/YyFrrZ+sOZh8tdsGL6+8meuo/GthjH/oh3zn+YOfcNsP1hW2iS0x
EO8dwcStq9xmJLJ2uwlZsvirYGVXBRYknOMrAgMBAAGjgYwwgYkwDAYDVR0TBAUw
AwEB/zAdBgNVHQ4EFgQUXcFoNzeBVGKtq7ZnA29CiJtNg0MwTQYDVR0jBEYwRIAU
XcFoNzeBVGKtq7ZnA29CiJtNg0OhFqQUMBIxEDAOBgNVBAMMB29wZW52cG6CFG70
l0hUnm/TCRbrR8Crk+t9dPnXMAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOC
AQEAoaMrw8syejg1KkvOSOlca2jnraQ+vVghz/fVaHXgVbAx2793A4AviVmcXV7B
VPtHkO/WqSuvRBjbTlWuieha1EdgsUjdZGItB0r8qnKr0FpQ/DPhbPqEEfYEVYYE
EQY41WUNcad5yZw3Q2Bm8aQIxfrwufJ81bwdmay1q8boMw6pyqNdAyeu1Tnjk3vV
LCaRGmYQB0xx4J1EiEvth6gmkkLJf1bsAcNpV4fOiLyAkdf7LwWLsxNMoJabuX9P
S3ptGZ7P/1o0jIyz4UdzFPR2vwJLTHr1i0roO6NNG5HzFUrb+rVHWeQbn0aHCj7y
ZiNd0hFG1VZZ3KoDvzukNjMKPw==
-----END CERTIFICATE-----
</ca>

<cert>
-----BEGIN CERTIFICATE-----
MIIDTDCCAjSgAwIBAgIQZP/pWI6HueNuGKLJuTLwajANBgkqhkiG9w0BAQsFADAS
MRAwDgYDVQQDDAdvcGVudnBuMB4XDTI1MDcwODA3MzUzMVoXDTI3MTAxMTA3MzUz
MVowETEPMA0GA1UEAwwGY2xpZW50MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAhvjgUPyJ2uvfYPuBX5FfKyQuZLTVfYDQ6nXi8WqS9SniESuriYg0ndVT
7cTvn4VgHTKPunjJQQDi0GJevBJZelVUEL1frpAgKy22NmX/e+PC2/aOgGsRvDl+
08nk3uKx40G8maEG9+IbeTmReih+phYALrUCg7KJIVRAZ8Z9Xpc63EILhBEZzkFN
CWzUBx3oQ/tNa0zAQs/Knj9B0GwuSuMWJeSFXn1JQa7bOzp3s4gSG+RVXnhHFZt6
C3/I3EYj44Qv2Td16CHh8Icr+S9RPFWQ30nJPXPDrZdSt8OyfwsAzzkRpFuvL5f9
fnytT6sOHHKN6v6d3p5A28xw/GgX8wIDAQABo4GeMIGbMAkGA1UdEwQCMAAwHQYD
VR0OBBYEFGK8aMBT79Jxru4u4Sd7v1aAjdXxME0GA1UdIwRGMESAFF3BaDc3gVRi
rau2ZwNvQoibTYNDoRakFDASMRAwDgYDVQQDDAdvcGVudnBughRu9JdIVJ5v0wkW
60fAq5PrfXT51zATBgNVHSUEDDAKBggrBgEFBQcDAjALBgNVHQ8EBAMCB4AwDQYJ
KoZIhvcNAQELBQADggEBAJUijOsbtcC9aPdOS3xSbUzDPJETwv0DgoOThb0sHtDR
2qUq4J/keGrySrpzXBnTeA0ZFa/R2CwoVpcAKHKFR877fAKsx6O6x7x5iiSsqgvt
rv6/vtP2aglYGQqKlZMgvu+s94jHdd21LgAg6u+sMGPjI/klsp/r1jH1JnKDWIef
sz/QW0kVU5KE99vmYFvs3S839NbQNbFX8WiYHUjaHInUdMALxOyq6p4Y5HWh+V7k
AM6LrBY2qMsTK20OcZemNy2j1dimbE5/PgWOeuXcA9Of+a1xXNLhaO6xGlp94wUq
2/hsusUy5hxPRHOjbk8QUUIw1F9qH19sFd2MeRxlKmY=
-----END CERTIFICATE-----
</cert>

<key>
-----BEGIN PRIVATE KEY-----
MIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCG+OBQ/Ina699g
+4FfkV8rJC5ktNV9gNDqdeLxapL1KeIRK6uJiDSd1VPtxO+fhWAdMo+6eMlBAOLQ
Yl68Ell6VVQQvV+ukCArLbY2Zf9748Lb9o6AaxG8OX7TyeTe4rHjQbyZoQb34ht5
OZF6KH6mFgAutQKDsokhVEBnxn1elzrcQguEERnOQU0JbNQHHehD+01rTMBCz8qe
P0HQbC5K4xYl5IVefUlBrts7OneziBIb5FVeeEcVm3oLf8jcRiPjhC/ZN3XoIeHw
hyv5L1E8VZDfSck9c8Otl1K3w7J/CwDPORGkW68vl/1+fK1Pqw4cco3q/p3enkDb
zHD8aBfzAgMBAAECgf8kgRLU1ISlEpQCaer1Ku5hmBIxEiU9zFw6q9hTvAVYYbJh
O58pSic6DvJCmWJmbTJUmt5EnOBLd3f5FOsEO9nfC34SjwzwQdn3in3V73cRYCbZ
oB6hR3iQrLMOS6TX4EdIhOB9b4mv4syv/LErG+EMqOagrxcjk4dquS3vFAkdc2Tf
MxOQlVf0Sd/CuH8Bjm+rbfLoAyl95wCtJiPPT2MQw4HQG91EMJTl2Kxj7MhJFOom
vUqaYn0eHcHjGl73Re2noBzsmkSnLu/wYl95c5aTG0oheEwXverylPe7hKoXT6y4
X9FzOW56embc5teyU718Ch8Itd309fk8SYmLXmECgYEAuWmS1iakDKwM1HNSoYer
e68Gxu5Wft4tEtOILdbTCVSJQZwQgKYBzIubQKsWhRmTM9uw8LMcIX/uxxIXdbYo
q/2R7r7Q1oX+1COkkH7EyHqttnfQI1avZauOpCEF4eURTQV9flg5QLKNR8k6vm3K
jtXfUvqIr226m4NV9QKu7nsCgYEAultcpgnR7IKkBwSV5xhuJdkPpDv2AKxojHPh
1lQEWGS3JBncm0c/e4HJew1mY+oKfRTCTnODEfHPJFks6qm4RO3vPU9kU5wnYr1v
XPgSch+SK7/eiTwwyPjKqvYiHQzcSPnLMP9jfEOgR9B7XQAPpw8Maa1MN66e4phK
bXTJ/ukCgYAWjcUSz7h84iDdZvnSNFKjxPKqGCvlWtlYxOp3yP360JGxrW5Ed+0Y
GJNWFnmyzx2c3Uh0vxTY7lr5VDYOV44y/bFWvVdiAQKyg3NtMD53tJSU8ZYb9lt3
nprHVE0G4XptSBGv4MN2H0IYTV4b8/cD0PhNe7RMwqhEaoF2QFFPKQKBgQCovEir
XoDhMXjrkc9ZK9mwE1YCUvhvq6wOYG6/7drxXmAlI/WH838biWyxKnTnSuasUruM
5TJscRIpy0TMRVg/sWDJlrU0r1NKKFRJTaUGCGgFjPkmMYXKstpu6eYBf7+FpAfD
GbsurNzXqYHJt2B01z9aADvevxHGAjaB3Rl44QKBgCHruaiOBrK6DtercnyJ1uNg
P/AMvFoMmkU1HOGOttWkyschI5eL2Br3gKzFzQZ1EqJxND0anbjmp3B7oT1OnSeM
MCodV9NSdT7fcBu52wZYSRCAs3kh1P5ncjsDMBk3qzw7S5GV64WI0+hQbz3KjDAn
BwMTednTrJBbM0qT51pa
-----END PRIVATE KEY-----
</key>

<tls-crypt>
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
ee53022e7a26fda037e46f06080ba02d
ebf34ab65ed62249e8c544df3dcf269a
97b5b3b9654b1cb2788b03a742f24d94
726497beb341de214ce04331778abb79
32fb265a69138aabbc4fad73b3f90a56
81f14653133adc966efce17096971a26
49d2dbaa4f07866722451843b2faacf8
19f9a79e3f15bd8eb193789d1687f90b
7832394c1e085d1e1f3b76488e20e8db
4725fdd9e7298ce4df9408e75884b64e
fb825113f5fbe8cee337bc0b2af5e813
786548aa96b819ee52ec06da28f34f8e
097a454c151adaba65b8db6b974220d4
a89ff00e91182df148e18d0ea6cc7786
7e4f38646f4510211a4428be98fe3b33
81c8f70790eb1150d6f601d85b28a8be
-----END OpenVPN Static key V1-----
</tls-crypt>



#####
# To create a user for vpn.
useradd -s /sbin/nologin <user>

# Generate a random passowrd
echo $RANDOM | sha256sum | head -c16

# Add the User in as DenyUsers /etc/ssh/sshd_config
DenyUsers <user1> <user2>

# Test and reload the sshd
sshd -t
systemctl reload sshd
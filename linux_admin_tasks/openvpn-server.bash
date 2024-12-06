# Set the system timezone to Asia/Kolkata (adjust according to your region if necessary).
timedatectl set-timezone Asia/Kolkata

# Register the system with Red Hat subscription service.
subscription-manager register

# Install essential utilities: bash-completion, vim, and firewalld for firewall management.
dnf -y install bash-completion vim firewalld

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
# OpenVPN manages VPN sessions and encrypted traffic (affects **data plane**, **forwarding plane**, and **control plane** for traffic encryption and session management).
# Easy-RSA is used to generate cryptographic keys and certificates (affects **control plane**, managing secure sessions).
dnf -y install openvpn easy-rsa

# Create a directory for Easy-RSA configuration files.
mkdir -p /ca

# Copy the Easy-RSA scripts and configuration files into the new directory.
# These files will help generate and manage the cryptographic keys and certificates.
cp -rv /usr/share/easy-rsa/3/* /ca

# Initialize the Public Key Infrastructure (PKI).
# This step creates the directory structure needed for managing certificates and keys.
# Affects the **control plane**, preparing the environment for managing secure communication sessions.
env -C /ca /ca/easyrsa init-pki

# Build the Certificate Authority (CA), which signs the server and client certificates.
# The CA is the trusted authority that ensures certificates are valid.
# Affects the **control plane**, as it manages the identity and trust in secure SSL/TLS sessions.
# Password: root@678
env -C /ca /ca/easyrsa build-ca

# Generate a private key and certificate request for the server.
# The server's private key and certificate are used to authenticate the server to clients.
# Affects the **control plane**, creating the server's cryptographic identity for secure communication.
env -C /ca /ca/easyrsa gen-req server nopass

# Sign the server certificate request with the CA.
# This ensures that the server's identity is validated by the CA, enabling trust between clients and the server.
# Affects the **control plane**, enabling secure session establishment.
env -C /ca /ca/easyrsa sign-req server server

# Generate Diffie-Hellman (DH) parameters for secure key exchange.
# DH ensures that keys exchanged between the server and client are securely negotiated.
# Affects the **control plane**, enabling secure encryption key exchange.
env -C /ca /ca/easyrsa gen-dh

# Generate a private key and certificate request for the client.
# Each client connecting to the VPN requires its own key and certificate for authentication.
# Affects the **control plane**, ensuring each client has a unique cryptographic identity.
env -C /ca /ca/easyrsa gen-req <client_cert_name> nopass
env -C /ca /ca/easyrsa gen-req client nopass

env -C /ca /ca/easyrsa sign-req client <client_cert_name>
env -C /ca /ca/easyrsa sign-req client client

/u01/easy-rsa/easyrsa --vars=/u01/easy-rsa/pki/vars gen-req client02 nopass
/u01/easy-rsa/easyrsa --vars=/u01/easy-rsa/pki/vars sign-req client client02

# Generate a static key for TLS authentication.
# TLS authentication adds an additional layer of security to prevent unauthorized connections.
# Affects the **control plane**, as TLS is used to secure session establishment.
openvpn --genkey secret /etc/openvpn/ta.key

# Copy the necessary certificates and keys to the OpenVPN configuration directory.
# These files are essential for the server to authenticate itself and encrypt the traffic between clients and the server.
# Affects both the **data plane** (for secure traffic flow) and the **control plane** (for managing cryptographic identities).
env -C /ca cp -v pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem /etc/openvpn

# Open the OpenVPN server configuration file for editing.
vim /etc/openvpn/server.conf

# Example OpenVPN Server Configuration

port 1194                         # OpenVPN listens on port 1194 (affects **data plane** and **forwarding plane**, managing traffic flow).
proto udp4                         # Use UDP as the transport protocol (Layer 4, Transport Layer).
dev tun                            # Use a TUN device (Layer 3, Network Layer) to route IP packets through the VPN (affects **data plane** and **forwarding plane**).
tls-server                         # Enable TLS to secure connections (Layer 5, Session Layer; affects **control plane** by managing session security).
ca /etc/openvpn/ca.crt             # Path to the Certificate Authority (CA) certificate (affects **control plane**, managing secure authentication).
cert /etc/openvpn/server.crt       # Path to the server's signed certificate (affects **control plane**, ensuring the server's identity).
key /etc/openvpn/server.key        # Path to the server's private key (affects **control plane**, securing data encryption and authentication).
dh /etc/openvpn/dh.pem             # Path to the Diffie-Hellman parameters (affects **control plane**, securing the key exchange process).
tls-crypt /etc/openvpn/ta.key      # Path to the TLS key for added security (affects **control plane**, preventing unauthorized session establishment).
auth SHA256                        # Use SHA256 for HMAC authentication (affects **control plane**, ensuring data integrity).
tun-mtu 1500                       # Set the MTU size for the TUN interface (Layer 3, Network Layer; affects **data plane**).
topology subnet                    # Use subnet topology (Layer 3, Network Layer; affects **data plane** by assigning unique IPs to clients).
server 10.0.7.0 255.255.255.0      # Define the internal VPN network (Layer 3, Network Layer; affects **data plane**).
keepalive 10 120                   # Ping clients every 10 seconds and disconnect after 120 seconds (Layer 5, Session Layer; affects **control plane** for session management).
push "redirect-gateway def1"       # Redirect all client traffic through the VPN (Layer 3, Network Layer; affects **data plane** and **forwarding plane**).
push "dhcp-option DNS 8.8.8.8"     # Push Google DNS to clients (Layer 3, Network Layer; affects **data plane** for DNS queries).
push "dhcp-option DNS 8.8.4.4"
data-ciphers AES-256-GCM:AES-128-GCM
data-ciphers-fallback AES-256-CBC                 # Use AES-256 encryption (Layer 5, Session Layer; affects **control plane** for data encryption).
status openvpn-status.log          # Output VPN server status (affects **control plane** for monitoring sessions).
verb 3                             # Set verbosity level for logging (affects **control plane** for troubleshooting).

# Enable IP forwarding on the server to allow traffic between VPN clients and the external network.
# This ensures that traffic can flow between VPN clients and external resources (Layer 3, Network Layer).
vim /etc/sysctl.conf
net.ipv4.ip_forward=1              # Enable IPv4 forwarding (Layer 3, Network Layer; affects **forwarding plane** and **data plane**).
net.ipv6.conf.all.forwarding=1     # Enable IPv6 forwarding (Layer 3, Network Layer; affects **forwarding plane** and **data plane**).

# Apply the IP forwarding settings.
sysctl --system

# Open the firewall for OpenVPN traffic on port 1194 (UDP).
# This allows clients to connect to the VPN server on the specified port.
# Affects **data plane** and **forwarding plane** by allowing VPN traffic.
firewall-cmd --add-port=49152/udp

# Enable IP masquerading (NAT) to allow VPN clients to access the internet.
# IP masquerading allows internal client traffic to be translated to the server's public IP for internet access.
# Affects **forwarding plane**, **data plane**, and **control plane**, as it routes and manages outgoing traffic.
firewall-cmd --add-masquerade

# Make firewall rules persistent across reboots.
firewall-cmd --runtime-to-permanent

vim /etc/systemd/system/openvpn.service
[Unit]
Description=OpenVPN Community Server
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/openvpn /etc/openvpn/server.conf
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target

#####
systemctl daemon-reload

systemctl enable --now openvpn

# Start the OpenVPN server using the configuration file.
# This will begin listening for client connections and route traffic securely through the VPN.
# Affects **data plane** (for encrypted traffic), **forwarding plane** (for traffic routing), and **control plane** (for session management and authentication).
nohup openvpn /etc/openvpn/server.conf &

# Client side

client
dev tun
proto udp4
remote 142.93.215.48 1195
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
MIIDPzCCAiegAwIBAgIUK5pAUFukfFYFeuvbTq49uTsA5T8wDQYJKoZIhvcNAQEL
BQAwEjEQMA4GA1UEAwwHanVwaXRlcjAeFw0yNDEwMDUwOTM5NDZaFw0zNDEwMDMw
OTM5NDZaMBIxEDAOBgNVBAMMB2p1cGl0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQD1iO5kmL24pcfifWKgqxlH6ZVIlBMi2t1WyJ6QisgvawYS5ipz
W2GkycJB3MqehmTHHYhNhV6e/3PbGplyNn8G/4oPcAKz3SBreeIIKyIjc8Cr/WqM
4bGdScFuKRUc3UZLPxfopjmVUCxShOWJlZv4UA8bWoGPh6RnTaoQv/IedNUeaA5X
Jr+tNwVyyMwetJu8EMsrgeftgD5xCxsio0jll6aI0jZJD6Et84WG6dUUggLaZbeZ
1iM9gG7p4CEA2o/qQbGGgMZxN+baJQBGd1463InO4l4ih53aUQvF+Gh9e0b1h3FM
yc9xdQWhwWoqFr42/yZIdgLulrAaBa5Nvb7zAgMBAAGjgYwwgYkwDAYDVR0TBAUw
AwEB/zAdBgNVHQ4EFgQUbgVN74Vv6GLoMWlR1IFXtVcnMqgwTQYDVR0jBEYwRIAU
bgVN74Vv6GLoMWlR1IFXtVcnMqihFqQUMBIxEDAOBgNVBAMMB2p1cGl0ZXKCFCua
QFBbpHxWBXrr206uPbk7AOU/MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOC
AQEAeyv7R6eJ/kJP7JKbZqY3V8gaU3R1MSEuHl0e+ZFlmLlaFF2Wh/E6bNjvY99w
/vWQyU+r4kydTjaT4uxHaG1nMybJ2UhCRUlGnRiFBD8nslC5HtpLGGotoDLKrDE1
+/9WuE3+9oBh3DjrNrHqbjHZsA8KFt2MyHKHbNrOKi8LdTeGWM8P1Z6RKiY6vM8c
MYhCq5QA6arY+58t5w1QSuxHIKM+yhlqlHalmbPDF3YBD/p5XDpxV7rZfzFZMhY9
qmFGQ9/+Kkh2o5H1kThDSTKQyvnORd+bkv9e/o7LbsgPKAuXxYBC5r1yG/cFuzJl
9rfp9pE0qQLA7Q2ZREMrjcII4Q==
-----END CERTIFICATE-----
</ca>

<cert>
-----BEGIN CERTIFICATE-----
MIIDTzCCAjegAwIBAgIRAJGbzQ/+xSrIfcTLWPoGDm8wDQYJKoZIhvcNAQELBQAw
EjEQMA4GA1UEAwwHanVwaXRlcjAeFw0yNDEwMDUwOTQ3MjhaFw0yNzAxMDgwOTQ3
MjhaMBMxETAPBgNVBAMMCGNsaWVudDAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAl/0MkQwsiLxPFd9zQ0r9h9YHmzvI6dob0n9pF7fJFBX3DVWbii3w
g3NREvzZH3ed5f6OMKcuS/3T6sRFm0mYvCQIQKH0l+L83LSrqXIWBO3VWfdwgmwH
8Jg/8plhzYLmG/Racx3wo2jkogQeJd4g+nVSQrJcjh3IkRNwViIgoLGi0E6tJyu4
AMlNj93Ko3cnqKnxLnBCp73xqCu3t61mhE3v0XUpTrTUW1MbusYaGrtLgd4piej/
8RlBC5d2BOHI5F9N2iZIFLEQvwi3GX1qipigb1DDX8km4+PkwgrNmdrouULgGARl
vb9HsDVN4mu3NJ9Jz5uTlLhuKFZviJNc+wIDAQABo4GeMIGbMAkGA1UdEwQCMAAw
HQYDVR0OBBYEFDsG2+S5qNP03d+gO9Idr9r0mBf9ME0GA1UdIwRGMESAFG4FTe+F
b+hi6DFpUdSBV7VXJzKooRakFDASMRAwDgYDVQQDDAdqdXBpdGVyghQrmkBQW6R8
VgV669tOrj25OwDlPzATBgNVHSUEDDAKBggrBgEFBQcDAjALBgNVHQ8EBAMCB4Aw
DQYJKoZIhvcNAQELBQADggEBAAUsRDmqFbcMk2+NdfwXCc6lZdojjjvAnsQscaKQ
SNxeG4LuCfZ3tLZDC1rP5RDtuEn3wH+UC/23N1UPL3P46pYx82qGko5goHQ/QZ8J
QGa379B5E8+ZcHH/n7Nuj05Bm7uZ16WefzgRE11OaQi8QUMGMfoi6EAGf5UqTJbu
VP/d3IiD5ummD+MDfL2i2hIpRGqJmeG6CqI+dV1YvXbOr+QtbQwZA9mp22Y7GBOv
4PUJY/X2TMYQdbGKflX4JK9g/jJX3f7gHhssYg/Zw1zmVg6SkPB1j0SRA7A0Rhri
MGSr7d0uW/Gcel6WY/lTBO2Li0D2u8z1KczH7+jjeBUXGWw=
-----END CERTIFICATE-----
</cert>

<key>
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCX/QyRDCyIvE8V
33NDSv2H1gebO8jp2hvSf2kXt8kUFfcNVZuKLfCDc1ES/Nkfd53l/o4wpy5L/dPq
xEWbSZi8JAhAofSX4vzctKupchYE7dVZ93CCbAfwmD/ymWHNguYb9FpzHfCjaOSi
BB4l3iD6dVJCslyOHciRE3BWIiCgsaLQTq0nK7gAyU2P3cqjdyeoqfEucEKnvfGo
K7e3rWaETe/RdSlOtNRbUxu6xhoau0uB3imJ6P/xGUELl3YE4cjkX03aJkgUsRC/
CLcZfWqKmKBvUMNfySbj4+TCCs2Z2ui5QuAYBGW9v0ewNU3ia7c0n0nPm5OUuG4o
Vm+Ik1z7AgMBAAECggEARgOt/EttYHfOvra2tDMhY6e2zU3XGdL9qhRDZ0eke3o6
2ourIRZUi1ld6a9MnfBObpq7CbKZ4yvEqYtMvWJD17eJjayNrkJEVa9svJvvhMnC
1LTlwU7ewXiBTNJXeYJpWktQN2N9bOlvGStob+1Jp9bP1CWx+U3DDQG1aBhEi4FT
Og1PR2OFQJ2FYGizEf/picxGZeEj6m9yZrP5DVlJw27Cqx0lMbU55aFiT8dZ/RNQ
kFqZ+ixCvkpCB2NR57tz4jHevxq92ndz2J1iyaClVa5S5F5cb8q8damgZyNaWVfT
awf/rTYgIuw6PCaPI3y3lrQe3kiijjHvrBGmxzmzAQKBgQDLj20gwVSm8gvwiUOT
bBSzAWHT2Zo1VbYeMXgVdYfwePyzxCxsXfsJ4fDb4dafhhMolutcjmk9J0b96ZKO
qWGyF/9JyGthLoPDUjlQF2aX4YmPinJLnKQ8XrR6+29hsQD2qMvy3i++EUBuH5W9
HdJnfA36P/ePQ0BgGGz9zhWgOwKBgQC/JIVHXiJCL/kpa1tRdp4Jl5Q531z/o04D
Z/6uPMRx2WKD5HKkSpKEQWyhA5uZritexRGLh7MBBjAUAZCNYS/osGlNNM5hSKpO
dX/0DLo3mV/a486R9omrPevy3jMTV6lifzalI4frfCiV05JcOlB2V5SAtKIPN0vx
7Txm2aQqQQKBgEvMuMI9u5v+/dswAe3fjUWq+ha9LOM3a32KxkCXZ2twYgk+v5wK
0vQ3Ik1+p0D32CKBMFti3GVdPt5GH8Dn6e07amC7NOEXRRFyiMz+KcHcxjChSTZG
uhGQ4nv5LNyf4M/4wxlJC1YnbmqTcFrfw/2tADdzomfCjzI5ZjyMhRkJAoGAQjY2
bOhw2ZigqPZlZay/RfdaA0oafvtk1M07bcPjEMUK2UFTbRHf+yxmosgLKIsqvuNp
FnplSZ+JHAUGu9LEs8gYUgRO0WhIhnExZ6rY/tWEXOC499r9CXKjvze1XafqJxKG
LWJHfQ0/SddGReh1YuknqgXodXjkN+PEHqSZt4ECgYEAwvcTUKPiRGw5MNZcaqSi
hBTCGwa8Ix0/zNnh6n9OPOUvMfvZ4+yQGp+oT/DW6DuDGnzmMVvX7LRVfPJUOQYQ
ZEljFLnICTZiO3Yjc2kniJOMD6gKKT0naVpJE5U0CiQFiH1OwNBk2z9PnY8RC58+
093z6lpLv7CGLKyA4pLfuqg=
-----END PRIVATE KEY-----
</key>

<tls-crypt>
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
3b3f2fcc76e4f132b3d94d31727848d4
2a3069959b4121dc20b324bf034d7759
e8d319ff4fe5fb53957851b1f7db801b
6d99180a83d737863ef24ab77142ef95
a7f025ed5816ecc91cff673dcb7f565b
a46b451e1bf8f1d7bb9621765a95a6f5
fd8e7bc5643ceae1031d524dd7ebdb84
d9f4859a04fe56a67be96e40850a6c90
9c26c8077a4fbc23f7d99b38ac2cf9f1
c828964286f92ccbe1e73691dedb723e
8ad29ba26584c48453b0ea434f5c8fb3
4787a7bd64aecaad465356eb102fa7b8
a4ba53456ed633eb8c6afdccccd8f2bb
dbc4e5455cbade9e771248c654a1de94
bb2bf4e495a06fd94badb252d367521e
afa0f7a77adc827b8842c6050ba46585
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
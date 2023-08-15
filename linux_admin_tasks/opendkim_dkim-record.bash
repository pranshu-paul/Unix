# DKIM (DomainKeys Identified Mail)

# Understanding the DKIM structure.
# "v" indicates the DKIM "version" (in this case, version 1).
# "k" specifies the "cryptographic algorithm" used for signing the message (in this case, RSA).
# "s" identifies the "selector" used to retrieve the corresponding public key from DNS.
# "p" contains the actual "public key".


# Install opendkim.
# Install EPEL repsitory.
dnf -y install opendkim opendkim-tools

# Generate a pair of public and private keys.
opendkim-default-keygen

# Change ownership and modes of the opendkim folder and files.
# Do not change the permission of default.private.
chown -Rv root:opendkim /etc/opendkim/keys
chmod -v 750 /etc/opendkim/keys

# Add/update the below lines in /etc/opendkim.conf

# To sign and verify emails at line number 39.
Mode     sv

# Comment the local socket line at line number 56.
Socket   inet:8891@localhost

# Add your domain name at line number 89.
Domain   paulpranshu.xyz

# Comment the below line at line number 99.
KeyFile        /etc/opendkim/keys/default.private

# Uncomment or add the follwing lines in /etc/opendkim.conf.

# at line number 104
KeyTable        		/etc/opendkim/KeyTable

# at line number 109
SigningTable   			refile:/etc/opendkim/SigningTable

# at line number 113
ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts

# at line number 116
InternalHosts   		refile:/etc/opendkim/TrustedHosts


# Add the path of the private key in /etc/opendkim/KeyTable.
default._domainkey.paulpranshu.xyz paulpranshu.xyz:default:/etc/opendkim/keys/paulpranshu.xyz/default.private

# Tell which emails to sign in /etc/opendkim/SigningTable.
*@paulpranshu.xyz default._domainkey.paulpranshu.xyz

# Add an entry of the trusted hosts in /etc/opendkim/TrustedHosts.
127.0.0.1
srv04.paulpranshu.xyz
paulpranshu.xyz

# Start and enable the opendkim service.
systemctl enable --now opendkim

# Test the configuration.
opendkim-testkey -d paulpranshu.xyz -s default -k /etc/opendkim/keys/default.private -vvv

# Verifing through the host command.
host -t txt default._domainkey.paulpranshu.xyz ns29.domaincontrol.com

# Check the private key from openssl.
openssl rsa -in /etc/opendkim/keys/default.private -check



# Tell postfix about the milter socket.
# "milter" stands for mail filter.
postconf -e "smtpd_milters = inet:127.0.0.1:8891"
postconf -e "non_smtpd_milters = $smtpd_milters"
postconf -e "milter_default_action = accept"
postconf -e "non_smtpd_milters = $smtpd_milters"

# Restart the postfix service.
systemctl restart postfix
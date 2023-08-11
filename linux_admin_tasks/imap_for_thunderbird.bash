# Download dovecot.
dnf -y install dovecot

# Create a Self Signed Certitcate with a CA.

# Create a Diffie-Helman parameter file.
openssl dhparam -out /etc/dovecot/dh.pem 2048

# Copy the CA, certificate, and private keys to their folders respectively.
cp -v ca.crt /etc/pki/dovecot/certs
cp -v dovecot.crt /etc/pki/dovecot/certs/dovecot
cp -v dovecot.key /etc/pki/dovecot/private

# Update the "ssl_cert" and "ssl_key" variables in file /etc/dovecot/conf.d/10-ssl.conf.
# Use the "<" sign while making an entry.
vi /etc/dovecot/conf.d/10-ssl.conf
ssl_cert = </etc/pki/dovecot/certs/dovecot.crt
ssl_key = </etc/pki/dovecot/private/dovecot.key

# Uncomment the following line in /etc/dovecot/conf.d/10-ssl.conf
ssl_ca = </etc/pki/dovecot/certs/ca.crt

ssl_dh = </etc/dovecot/dh.pem

# Create a user for IMAP.
useradd --home-dir /var/mail/ --shell /usr/sbin/nologin vmail

chown vmail:vmail /var/mail/
chmod 700 /var/mail/

# Uncomment and update the following line in /etc/dovecot/conf.d/10-mail.conf
mail_location = mbox:~/mail:INBOX=/var/mail/%u

# Update the following line in /etc/dovecot/conf.d/10-mail.conf
first_valid_uid = 1000

# Add the following content in /etc/dovecot/conf.d/auth-system.conf.ext
userdb {
driver = passwd
override_fields = uid=1002 gid=1002 home=/var/mail/%n/
}

# Create a relay domain file.
# To allow the mail server being used as a relay server.
vi /etc/postfix/relay_domains
paulpranshu.xyz smtp:

# Create a hash file of the relay_domains
postmap /etc/postfix/relay_domains

# Update the relay_domains variable.
postconf -e relay_domains = hash:/etc/postfix/relay_domains

# Update protocols in /etc/dovecot/dovecot.conf
protocols = imap lmtp pop3

# Open the firewall.
firewall-cmd --permanent --add-service={imaps,imap,pop3s,pop3}
firewall-cmd --reload

# Enable and start the dovecot service.
systemctl enable --now dovecot

# Show the non-default values.
doveconf -n

# Download the "ca.crt"
# Import the certificate in thunderbird.

# Login in thunderbird and verify.
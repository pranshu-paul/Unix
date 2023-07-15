# Postifx wrapper script
# Port 25 must be unblocked.

# Set FQDN in your mail server.

# Create the following records for your mail server domain name.
# MX, A, PTR, TXT, SPF

# Add entry in /etc/hosts file.

#Install Postfix and Mailx mail client.
dnf -y install postfix mailx

postconf mail_version # -- to check postfix mail version

rpm -ql postfix | grep /usr/sbin # -- to list all associated binaries with postfix

postconf -e "inet_interfaces = all" # -- to allow postconf to edit postfix main.cf
postconf inet_interfaces  # -- to list interface for postfix
postconf -e "inet_protocols = all"
postconf inet_protocols
postconf -e "myhostname = mail.oswebadmin.com" # -- to chnage hostname for mail server
postconf myhostname # -- to list hostname for mail server
postconf -e "mydomain = oswebadmin.com" # -- to change your domain name
postconf mydomain # -- to list my domain
postconf -e "myorigin = oswebadmin.com" # -- to change domain name
postconf myorigin # -- defines default domain name for the server
postconf -e "mydestination = oswebadmin.com, \$myhostname, localhost.\$mydomain, localhost" # -- change my destinationa long with the interface 
postconf mydestination # -- displays final destination for the our mail server
postconf -e "home_mailbox = Maildir/"

# Enabling TLS in postfix.
# For TLS httpd is required and certbot(Let'sEncrypt)

#postconf -e "smtpd_tls_cert_file = /etc/pki/tls/certs/httpd.crt"
#postconf smtpd_tls_cert_file
#postconf -e "smtpd_tls_key_file = /etc/pki/tls/private/httpd.key"
#postconf smtpd_tls_key_file
#postconf -e "smtpd_use_tls = yes"
#postconf smtpd_use_tls
#postconf -e "smtp_use_tls = yes"
#postconf smtp_use_tls

postconf mail_spool_directory

firewall-cmd --add-service=smtp --permanent && firewall-cmd --reload

# Start Postfix daemon.
systemctl daemon-reload
systemctl enable --now postfix


####################################################################################################
# Postfix Relay

cat >> /etc/postfix/sasl_passwd << EOF
[smtp.gmail.com]:587    testing.paulpranshu@gmail.com:<PASSWORD>
EOF

postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd


postconf -e "relayhost = [smtp.gmail.com]:587"
postconf -e "smtp_use_tls = yes"
postconf -e "smtp_sasl_auth_enable = yes"
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf -e "smtp_tls_CAfile = /etc/ssl/certs/postfix.pem"
postconf -e "smtp_sasl_security_options = noanonymous"
postconf -e "smtp_sasl_tls_security_options = noanonymous"

systemctl restart postfix




############################################################################
Mutt client configuration
# To run mutt first we need to set up mutt configuration file.
# Default folder for mutt is ~/.muttrc

# Here is a sample configuration file(.muttrc).

# Port for imap = 993 and smtp = 587

# set folder = "imaps://testing.paulpranshu@gmail.com@imap.gmail.com:993"
# set spoolfile = "+INBOX"
# set smtp_url = "smtp://testing.paulpranshu@gmail.com@smtp.gmail.com:587"
# set smtp_pass = "PASSWORD"
# set imap_pass = "PASSWORD"
# set from = "testing.paulpranshu@gmail.com"
# set realname = "Pranshu Paul"


# To send email from command line.
# -s SUBJECT -c CARBON COPY -b BLIND CARBON COPY -a ATTACHMENT
# echo MESSAGE | mutt -s "SUBJECT" -c CARBON COPY -b BLIND CARBON COPY MAIL RECIPIENT -a # PATH TO ATTACHMENT
echo Hello | mutt -s "Test mail" -c someone@somwhere.com -b someone2@somwhere.com someone3@somwhere.com -a /etc/os-release

# HereDoc can be also use a message writing for email.
cat << HereDoc mutt -s "Mutt" someone@somwhere.com
Message can be type in this format.
This is a email.
HereDoc

# Commands output can be also send as stdin to mutt.
nmcli dev status | mutt -s "Mutt" someone@somwhere.com# To install nc.
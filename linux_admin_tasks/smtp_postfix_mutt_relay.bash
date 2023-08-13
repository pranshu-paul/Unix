# Creating a basic SMTP server for sending and recieving emails.

# Port 25 must be unblocked.

# Set FQDN in your mail server.

# Create the following records for your mail server domain name.
# MX, A, CNAME, PTR (rDNS), TXT, SPF

# Required DNS records.
# A Record: Main domain record.
@	600	 IN 	A	<ip_address>

# TXT Record: For SPF and google postmaster
@	3600	 IN 	TXT	"google-site-verification=gmwzrZZrWrcySxAZ-WNbp6YLOzZTrDzrIzY1tA-YVY4"
@	3600	 IN 	TXT	"v=spf1 +a +mx +ip4:<ip_address> ~all"

# CNAME Record: For MX record, it must be pingable.
<hostname>	3600	 IN 	CNAME	@

# MX Record: For incoming emails.
@	3600	 IN 	MX	0	<hostname>.<domain>.<tld>.


# Add DKIM (Domain Key Identified Mail) record (see openssl).

# Add a DMARC (Domain-based Message Authentication, Reporting, and Conformance)
TXT	v=DMARC1; p=none; rua=mailto:testing.paulpranshu@gmail.com; ruf=mailto:testing.paulpranshu@gmail.com; fo=1; adkim=s; aspf=s; pct=100;

# Add an entry in /etc/hosts file.

# Install Postfix and Mailx mail client.
dnf -y install postfix mailx

postconf mail_version # -- To check postfix mail version

rpm -ql postfix | grep /usr/sbin # -- to list all associated binaries with postfix

postconf -e "inet_interfaces = all" # -- to allow postconf to edit postfix main.cf
postconf inet_interfaces  # -- to list interface for postfix
postconf -e "inet_protocols = all"
postconf inet_protocols
postconf -e "myhostname = <hostname>" # -- to chnage hostname for mail server
postconf myhostname # -- to list hostname for mail server
postconf -e "mydomain = <domain_name>" # -- to change your domain name
postconf mydomain # -- to list my domain
postconf -e "myorigin = <domain_name>" # -- to change domain name
postconf myorigin # -- defines default domain name for the server
postconf -e "mydestination = <domain_name>, \$myhostname, localhost.\$mydomain, localhost" # -- change my destination along with the interface 
postconf mydestination # -- displays final destination for the our mail server
postconf mail_spool_directory
postconf mailbox_size_limit

# Enabling TLS in postfix.
# For TLS httpd is required and certbot(Let's Encrypt)
# Or, we could generate a Let's Encrypt certificate from punchsalad.com

#postconf -e "smtpd_tls_cert_file = /etc/pki/tls/certs/postfix.crt"
#postconf smtpd_tls_cert_file
#postconf -e "smtpd_tls_key_file = /etc/pki/tls/private/postfix.key"
#postconf smtpd_tls_key_file
#postconf -e "smtpd_use_tls = yes"
#postconf smtpd_use_tls
#postconf -e "smtp_use_tls = yes"
#postconf smtp_use_tls

# Open port 25/tcp or add the service SMTP.
firewall-cmd --add-service=smtp --permanent && firewall-cmd --reload

# Start Postfix daemon.
systemctl daemon-reload
systemctl enable --now postfix


####################################################################################################
# Postfix Relay

# Download Postfix.
dnf -y install postfix

# Run the below command to add the SMTP server's credentials.
cat >> /etc/postfix/sasl_passwd << EOF
[smtp.gmail.com]:587    testing.paulpranshu@gmail.com:<password>
EOF

# Create a hashed version of the file "/etc/postfix/sasl_passwd".
# Change it's permissions to 400.
postmap /etc/postfix/sasl_passwd
chmod 400 /etc/postfix/sasl_passwd

# Set the relayhost.
# It doesn't deliver locally.
postconf -e "relayhost = [smtp.gmail.com]:587"
postconf relayhost

# Enable smtp TLS.
postconf -e "smtp_use_tls = yes"
postconf smtp_use_tls

# Enable SASL (Simple Authentication and Security Layer) to yes.
# Tu authenticate with the SMTP server postfix will use the above credentials.
postconf -e "smtp_sasl_auth_enable = yes"
postconf smtp_sasl_auth_enable

# Provide the path of the hashed file.
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf smtp_sasl_password_maps

# Provide the path of the local CA authority.
postconf -e "smtp_tls_CAfile = /etc/ssl/certs/postfix.pem"
postconf smtp_tls_CAfile

postconf -e "smtp_sasl_security_options = noanonymous"
postconf smtp_sasl_security_options

postconf -e "smtp_sasl_tls_security_options = noanonymous"
postconf smtp_sasl_tls_security_options

# Restart the postfix service.
systemctl restart postfix


# To test e-mail dry run.
echo "This is a test email" | mailx -s "Test Subject" -n recipient@example.com


############################################################################
# Mutt client configuration
# To run mutt first we need to set up mutt configuration file.
# Default configuration file of mutt at a user level is ~/.muttrc
# Same configuration can be run on Solaris as well.

# Here is a sample configuration file(.muttrc).

# Port for imap = 993 and smtp = 587

# For incoming.
set folder = "imaps://testing.paulpranshu@gmail.com@imap.gmail.com:993"
set imap_pass = "<password>"

# For outgoing only.
set spoolfile = "+INBOX"
set smtp_url = "smtp://testing.paulpranshu@gmail.com@smtp.gmail.com:587"
set smtp_pass = "<password>"
set from = "testing.paulpranshu@gmail.com"
set realname = "Pranshu Paul"
set editor= "vi"
set pager = "less"
set signature = "Sent from Oracle Solaris"


# To send email from the command line.
# -s SUBJECT -c CARBON COPY -b BLIND CARBON COPY -a ATTACHMENT
# echo <message> | mutt -s "<subject>" -c <carbon_copy> -b <blind_carbon_copy> <mail_recipient> -a <attachment_path>
echo Hello | mutt -s "Test mail" -c someone@somwhere.com -b someone2@somwhere.com someone3@somwhere.com -a /etc/os-release

# HereDoc can be also use a message writing for email.
cat << EOF mutt -s "Mutt" someone@somwhere.com
Message can be type in this format.
This is a email.
EOF

# Commands output can be also send as stdin to mutt.
nmcli dev status | mutt -s "Test mail" someone@somwhere.com
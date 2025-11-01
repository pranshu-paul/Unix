echo 'daily_clean_hoststat_enable="NO"' >> /etc/periodic.conf
echo 'daily_status_mail_rejects_enable="NO"' >> /etc/periodic.conf
echo 'daily_status_include_submit_mailq="NO"' >> /etc/periodic.conf
echo 'daily_submit_queuerun="NO"' >> /etc/periodic.conf

yes | pkg install postfix

sysrc sendmail_enable="NONE"
sysrc postfix_enable="YES"

install -dv /usr/local/etc/mail
install -vm 0644 /usr/local/share/postfix/mailer.conf.postfix /usr/local/etc/mail/mailer.conf

mkdir -v /usr/local/etc/ssl

openssl req \
-x509 \
-nodes \
-days 365 \
-newkey rsa:4096 \
-keyout /usr/local/etc/ssl/postfix.key \
-out /usr/local/etc/ssl/postfix.crt \
-subj "/CN=*.paulpranshu.xyz"

postconf -e "mydomain = paulpranshu.xyz"
postconf -e "myhostname = paulpranshu.xyz"
postconf -e "smtpd_tls_cert_file = /usr/local/etc/ssl/postfix.crt"
postconf -e "smtpd_tls_key_file = /usr/local/etc/ssl/postfix.key"
postconf -e "smtpd_tls_auth_only = yes"
postconf -e "smtpd_use_tls = yes"
postconf -e "smtp_use_tls = yes"

# Add the below line at the file /etc/mail/aliases below at the line number 19 to receive emails.
# sed -i '' 's/# root:/root: root@paulpranshu.xyz/' /etc/mail/aliases
newaliases

service postfix start

# Adding the other users.
! grep 'paul: paul@paulpranshu.xyz' /etc/mail/aliases && echo 'paul: paul@paulpranshu.xyz' >> /etc/mail/aliases
newaliases

# Troubleshooting
tail /var/log/maillog

grep postfix/smtp /var/log/maillog

# Add the below line in the file /usr/local/etc/postfix/master.cf to enable submission port
submission inet n - y - - smtpd
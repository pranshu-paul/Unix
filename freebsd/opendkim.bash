pw useradd -n opendkim -d /var/db/opendkim -m -s "/usr/sbin/nologin" -w no

yes | pkg install opendkim

# Take a backup of the file /usr/local/etc/mail/opendkim.conf.
install -v /usr/local/etc/mail/opendkim.conf /usr/local/etc/mail/opendkim.conf.org

opendkim-genkey -D /var/db/opendkim -d paulpranshu.xyz -s default

chown -Rv root:opendkim /var/db/opendkim
chmod -v 750 /var/db/opendkim
chown -v opendkim:opendkim /var/db/opendkim/default.private


# Remove the contents of the /usr/local/etc/mail/opendkim.conf.
> /usr/local/etc/mail/opendkim.conf

# Add the below content in the file /usr/local/etc/mail/opendkim.conf.
cat > /usr/local/etc/mail/opendkim.conf << EOF
Domain                  paulpranshu.xyz
ExternalIgnoreList      refile:/usr/local/etc/opendkim/TrustedHosts
InternalHosts           refile:/usr/local/etc/opendkim/TrustedHosts
KeyFile                 /var/db/opendkim/default.private
KeyTable                /usr/local/etc/opendkim/KeyTable
Mode                    sv
Selector                default
SigningTable            refile:/usr/local/etc/opendkim/SigningTable
Socket                  inet:8891@localhost
Syslog                  Yes
ReportAddress           root
LogWhy                  yes
Syslog                  yes
SyslogSuccess           yes
Canonicalization        relaxed/simple
UserID                  opendkim:opendkim
EOF

mkdir -pv /usr/local/etc/opendkim

# Add the path of the private key in /usr/local/etc/opendkim/KeyTable.
echo 'default._domainkey.paulpranshu.xyz paulpranshu.xyz:default:/var/db/opendkim/default.private' > /usr/local/etc/opendkim/KeyTable

# Tell which emails to sign in /usr/local/etc/opendkim/SigningTable.
echo '*@paulpranshu.xyz default._domainkey.paulpranshu.xyz' > /usr/local/etc/opendkim/SigningTable

# Add an entry of the trusted hosts in /usr/local/etc/opendkim/TrustedHosts.
cat > /usr/local/etc/opendkim/TrustedHosts << EOF
127.0.0.1
srv04.paulpranshu.xyz
paulpranshu.xyz
EOF


# Add the below entry in the DNS resource records.
# default._domainkey      IN      TXT    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDG/oa1+ve0bKNq+Bl1yTRDNwOXpNSR02vEYGBYmznmpnxi9V18Ofl3xeHlAHdSMFFHxoDzpZf7FATgXW6sNq7LU9AxLMQil/U9zr4OehCaMEHdBfAZ+QxOUDJxQfY32Rn9fpaKJKxk13A8NcrKtH0mFR98dHlEwtFnSD6MVv01UQIDAQAB"

echo add the below entry in the DNS resource records.

cat /var/db/opendkim/default.txt

# Test the key
opendkim-testkey -vvv -d paulpranshu.xyz -s default -k /var/db/opendkim/default.private

sysrc milteropendkim_enable="YES"
sysrc milteropendkim_uid="opendkim"
sysrc milteropendkim_gid="opendkim"

host -t txt default._domainkey.paulpranshu.xyz

postconf -e "smtpd_milters = inet:127.0.0.1:8891"
postconf -e "non_smtpd_milters = \$smtpd_milters"
postconf -e "milter_default_action = accept"

service milter-opendkim start

service postfix restart




# Troubleshooting
grep -v -e '^#' -e '^$' /usr/local/etc/mail/opendkim.conf

# Trash
mkdir -pv /usr/local/etc/opendkim/keys



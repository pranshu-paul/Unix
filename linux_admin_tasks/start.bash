#!/bin/bash

# Set the  variables.
host_name=srv
domain_name=oswebadmin.com
fqdn="${host_name}.${domain_name}"
time_zone=Asia/Kolkata
user_name=username
password=password
system_packages=(bash-completion vim-enhanced firewalld nmap-ncat bind-utils policycoreutils-python)
apache_packages=(httpd mod_ssl openssl)
postfix_packages=(postfix mailx mutt)
User=paul
passcode=paul123
Httpcrt=httpd
Httpkey=httpd
websitename=mail."$domain_name"

# Checking, whether the script is running from root user or not.
if [[ "${UID}" -ne 0 ]]
then
	echo "Please run this script either with root user or sudo permission."
	exit 1
fi

# Showing RHEL version.
echo -e "Operating System being used. \n$(cat /etc/system-release)"

timezone ()
{
if [[ $(timedatectl | grep -oq "${time_zone}") != "${time_zone}" ]]
then
	timedatectl set-timezone "${time_zone}"
	echo Timezone is "$(timedatectl | grep -o "${time_zone}")."
else
	echo -e "\nTimezone is already set.\n$(timedatectl | grep -o ${time_zone})"
fi
}

if timedatectl list-timezones | grep -o "${time_zone}"
then
	timezone
else
	echo "Invalid timezone provided ${time_zone}."
fi

fqdn ()
{
hosts_entry="$(hostname -I | awk '{print $1}') "${fqdn}" "${host_name}""
if ! grep -oq "${hosts_entry}" /etc/hosts
then
	echo -e "\nChanging hostname to ${host_name} and FQDN to ${fqdn}."
	echo "${hosts_entry}" >> /etc/hosts
	hostnamectl set-hostname "${host_name}"
	echo -e "Hostname and FQDN changed to $(hostname) and $(hostname -f) respectively."
else
	if ! [[ "$(hostname)" == "${host_name}" ]] && ! [[ "$(hostname -f)" == "${fqdn}" ]]
	then
		echo -e "\nChanging hostname to ${host_name} and FQDN to ${fqdn}."
		hostnamectl set-hostname "${host_name}"
		echo -e "Hostname and FQDN changed to $(hostname) and $(hostname -f) respectively."
	else
		echo "FQDN is already set to $(hostname -f)"
	fi
fi
}
fqdn

subscription ()
{
if rpm -q subscription-manager &> /dev/null && \
grep -q "Red Hat Enterprise Linux" /etc/redhat-release && \
! subscription-manager identity &> /dev/null
then
	subscription-manager register --username "${user_name}" --password "${password}"
	subscription-manager role --set="Red Hat Enterprise Linux Server"; else
	echo -e "\nThis system has already a subscription."; fi
}
# subscription

pkgs ()
{
if [[ -n "${PKGS[@]}" ]]
then
	echo -e "\nInstalling package[s] ..."
	printf "%s\n" "${PKGS[@]}"
	yum -y install "${PKGS[@]}" &> /dev/null && echo -e "\nPackage[s] installed. \n${PKGS[@]}."
		
		# If packages installation get failed.
		if [[ "${?}" -eq 0 ]]
		then
			echo "Something went wrong while installing packages."
			exit 1
		fi
else
	echo -e "\nPackage[s] already installed."
	printf "%s\n" "${PACKAGES[@]}"
fi
}

PKGS=($(rpm -q "${system_packages[@]}" | awk '{print $2}' | sort | sed '/^$/d'))
pkgs

if ! systemctl is-enabled firewalld &> /dev/null; then
systemctl enable --now firewalld; fi

if grep -q ^"${User}" /etc/passwd; then
echo "User ${User} already exists."; else
adduser "${User}" && echo "User added ${User}."
usermod -aG wheel "${User}"
echo "${passcode}" | passwd --stdin "${User}"
su - "${User}" -c "cd ~;mkdir .ssh;chmod 700 .ssh;cd .ssh;touch authorized_keys;chmod 600 authorized_keys;cd ~"; fi

echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
chmod 0440 /etc/sudoers.d/wheel

# APAPCHE WEB SERVER CONFIGURATION.
PKGS=($(rpm -q "${apache_packages[@]}" | awk '{print $2}' | sort))
# CALLING FUNCTION PKGS
pkgs

openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout "${Httpkey}".key -out "${Httpcrt}.crt" \
-subj "/C=IN/ST=Delhi/L=Delhi/O=OSWebAdmin/OU=Linux administration/CN=*.${domain_name}" &> /dev/null

if [[ ! -f /etc/pki/tls/certs/"${Httpcrt}".crt ]]
then
mv "${Httpcrt}".crt /etc/pki/tls/certs/
fi

if [[ ! -f /etc/pki/tls/private/"${Httpkey}".key ]]
then
mv "${Httpkey}".key /etc/pki/tls/private/
fi

sed -i "s/localhost.crt/${Httpcrt}.crt/g" /etc/httpd/conf.d/ssl.conf;sed -i "s/localhost.key/${Httpkey}.key/g" /etc/httpd/conf.d/ssl.conf

restorecon -Rrv /etc/pki/tls/certs/"${Httpcrt}".crt

restorecon -Rrv /etc/pki/tls/private/"${Httpkey}".key

apachectl configtest

if ! systemctl is-enabled httpd &> /dev/null; then
systemctl enable --now httpd; fi

if ! firewall-cmd --list-services | grep -q https; then
firewall-cmd --add-service=https --permanent && firewall-cmd --reload; fi

if systemctl restart httpd 2> /dev/null
then
	echo "Service httpd is restarted."
else
	echo "Something went wrong while restarting service httpd."
	exit 1
fi

# ADDING HTTPD VIRTUAL HOST.
webpage ()
{
if [[ ! -d /var/www/"${websitename}"/html ]]; then
mkdir -p /var/www/"${websitename}"/html; fi

chmod -R 755 /var/www

if [[ ! -f /var/www/"${websitename}"/html/index.html ]]; then
cat << EOF > /var/www/"${websitename}"/html/index.html
<html>
<head>
<title>Welcome to "${websitename}"!</title>
</head>
<body>
<h1>Success! The "${websitename}" virtual host is working!</h1>
</body>
</html>
EOF
fi

if ! [[ -f /etc/httpd/conf.d/"${websitename}".conf ]]; then
cat >> /etc/httpd/conf.d/"${websitename}" << EOF
<VirtualHost *:443>
		DocumentRoot /var/www/${websitename}/html
		ServerName ${websitename}
		CustomLog /var/log/httpd/${websitename}_access.log combined
		ErrorLog /var/log/httpd/${websitename}_error.log
		SSLEngine on
		SSLCertificateFile /etc/pki/tls/certs/"${Httpcrt}".crt
		SSLCertificateKeyFile /etc/pki/tls/private/"${Httpkey}".key
	<Directory /var/www/"${websitename}"/html>
			Options Indexes FollowSymLinks
			Allowoverride none
			Require all granted
	</Directory>
</VirtualHost>
EOF
fi

chown -R apache:apache /var/www

if ! semanage fcontext -l | grep -o "${websitename}" > /dev/null
then
	semanage fcontext -a -t httpd_sys_content_t "/srv/${websitename}(/.*)?"
	restorecon -Rv /var/www/"$websitename"/
fi
}

webpage

websitename=downloads."${domain_name}"

webpage

# Postfix configuration.
PKGS=($(rpm -q "${postfix_packages[@]}" | awk '{print $2}' | sort))
# Function pkgs.
pkgs

if ! grep -q "${domain_name}" /etc/postfix/main.cf; then
postconf mail_version 
postconf -e "inet_interfaces = all"
postconf inet_interfaces
postconf -e "inet_protocols = all"
postconf inet_protocols
postconf -e "myhostname = $Hostname"
postconf myhostname
postconf -e "mydomain = $domain_name"
postconf mydomain
postconf -e "myorigin = $domain_name"
postconf myorigin
postconf -e "mydestination = $domain_name, \$myhostname, localhost.\$mydomain, localhost"
postconf mydestination
postconf -e "smtpd_tls_cert_file = /etc/pki/tls/certs/httpd.crt"
postconf smtpd_tls_cert_file
postconf -e "smtpd_tls_key_file = /etc/pki/tls/private/httpd.key"
postconf smtpd_tls_key_file
postconf -e "smtpd_use_tls = yes"
postconf smtpd_use_tls
postconf -e "smtp_use_tls = yes"
postconf smtp_use_tls
postconf mail_spool_directory
postconf mailbox_size_limit
fi

if ! firewall-cmd --list-services | grep -q smtp; then
firewall-cmd --add-service=smtp --permanent && firewall-cmd --reload; fi

systemctl daemon-reload;systemctl enable --now postfix;systemctl restart postfix
ss -lnpt | grep master
exit $?
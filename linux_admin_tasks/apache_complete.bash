# Download the below packages.
dnf -y install httpd openssl mod_ssl

# Enable and start the apache server.
systemctl enable --now httpd

# Run the below command to turn off the default http port.
sed -i '45s/^Listen 80/#Listen 80/' /etc/httpd/conf/httpd.conf

# Check the statement in the file at the line number 45.
sed -n '45p' /etc/httpd/conf/httpd.conf

# Create a self signed certificate for the https protocol.
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout httpd.key -out httpd.crt \
-subj "/C=IN/ST=Delhi/L=Delhi/O=OSWebAdmin/OU=Linux administration/CN=*.oswebadmin.com" &> /dev/null

# Move the files created earlier in their respective directories.
mv httpd.crt /etc/pki/tls/certs/
mv httpd.key /etc/pki/tls/private/

# Change the SElinux context for the below files.
restorecon -Rrv /etc/pki/tls/certs/httpd.crt
restorecon -Rrv /etc/pki/tls/private/httpd.key

# Create a directory for the website to be made.
mkdir -p /var/www/rhel.com

# Change ownership and group membership to apache.
chown -R apache:apache /var/www

# Create a sample HTML file for the testing purpose.
cat > /var/www/rhel.com/index.html << EOF
<html>
<head>
<title>Welcome to rhel.com!</title>
</head>
<body>
<h1>Success! The rhel.com virtual host is working!</h1>
</body>
</html>
EOF

# Create a virtual host for the website in the directory "/etc/httpd/conf.d"
cat > /etc/httpd/conf.d/rhel.com.conf << EOF
<VirtualHost *:443>
		DocumentRoot /var/www/rhel.com
		ServerName rhel.com
		CustomLog /var/log/httpd/rhel.com_access.log combined
		ErrorLog /var/log/httpd/rhel.com_error.log
		SSLEngine on
		SSLCertificateFile /etc/pki/tls/certs/httpd.crt
		SSLCertificateKeyFile /etc/pki/tls/private/httpd.key
	<Directory /var/www/rhel.com/html>
			Options Indexes FollowSymLinks
			Allowoverride none
			Require all granted
	</Directory>
</VirtualHost>
EOF

# Tell SElinux about the changes made.
semanage fcontext -a -t httpd_sys_content_t "/srv/rhel.com(/.*)?"
restorecon -Rv /var/www/rhel.com

# Restart the apache service.
systemctl restart httpd

# Open the HTTPS port on firewall.
firewall-cmd --add-port=443/tcp
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-service={https,http} --permanent
# Download the below packages.
dnf -y install httpd mod_ssl

# Enable and start the apache server.
systemctl enable --now httpd

# Run the below command to turn off the default http port.
sed -i '45s/^Listen 80/#Listen 80/' /etc/httpd/conf/httpd.conf

# Check the statement in the file at the line number 45.
sed -n '45p' /etc/httpd/conf/httpd.conf

# Create a self signed certificate for the https protocol.
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout server.key -out server.crt -subj "/CN=*.example.com"

# Move the files created earlier in their respective directories.
mv httpd.crt /etc/pki/tls/certs/
mv httpd.key /etc/pki/tls/private/

# Change the SElinux context for the below files.
restorecon -Rrv /etc/pki/tls/certs/httpd.crt
restorecon -Rrv /etc/pki/tls/private/httpd.key

echo "$(hostname -I | awk '{print $1}') niteshkumar.org" >> /etc/hosts

# Create a directory for the website to be made.
mkdir -p /var/www/niteshkumar.org

# Change ownership and group membership to apache.
chown -R apache:apache /var/www

# Create a sample HTML file for the testing purpose.
echo "Success! The $(hostname) virtual host is working!" > /var/www/niteshkumar.org/index.html

# Create a virtual host for the website in the directory "/etc/httpd/conf.d"
cat > /etc/httpd/conf.d/niteshkumar.org.conf << EOF
Listen 443
<VirtualHost *:443>
		DocumentRoot /var/www/niteshkumar.org
		ServerName niteshkumar.org
		CustomLog /var/log/httpd/niteshkumar_access.log combined
		ErrorLog /var/log/httpd/niteshkumar_error.log
		SSLEngine on
		SSLCertificateFile /etc/pki/tls/certs/httpd.crt
		SSLCertificateKeyFile /etc/pki/tls/private/httpd.key
	<Directory /var/www/niteshkumar.org>
			Options Indexes FollowSymLinks
			Allowoverride none
			Require all granted
	</Directory>
</VirtualHost>
EOF

# Tell SElinux about the changes made.
semanage fcontext -a -t httpd_sys_content_t "/srv/niteshkumar.org(/.*)?"
restorecon -Rv /var/www/niteshkumar.org

# Check the configuration syntax.
# ignore the ServerName warning, if Syntax OK prints.
apachectl configtest

# Restart the apache service.
systemctl restart httpd

# Open the HTTPS port on firewall.
firewall-cmd --add-port=443/tcp
firewall-cmd --add-port=443/tcp --permanent
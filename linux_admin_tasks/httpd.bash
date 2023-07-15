dnf -y install httpd mod_ssl openssl
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout httpd.key -out httpd.crt
cp httpd.crt /etc/pki/tls/certs/
cp httpd.key /etc/pki/tls/private/
sed -i 's/localhost.crt/httpd.crt/g' /etc/httpd/conf.d/ssl.conf
sed -i 's/localhost.key/httpd.key/g' /etc/httpd/conf.d/ssl.conf
apachectl configtest
firewall-cmd --add-service={https,http} --permanent
firewall-cmd --reload
systemctl enable --now httpd

#openssl req -new -newkey rsa:4096 -nodes -out star_oswebadmin_com.csr -keyout star_oswebadmin_com.key -subj "/C=IN/ST=Delhi/L=Delhi/O=OSWebAdmin/OU=Linux administration /CN=*.oswebadmin.com"
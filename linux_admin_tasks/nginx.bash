# Install epel repo
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Install php remi repo.
dnf -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm

# Enable php remi 8.2 module.
dnf -y module enable php:remi-8.2

# Install php and osTicket dependencies
dnf -y install php php-common php-fpm php-cgi php-bcmath php-gd php-imap php-intl php-apcu php-cli php-mbstring php-curl php-mysql php-xml

# Install nginx
dnf -y module enable nginx:1.24

# Start nginx
systemctl start nginx

# Install certbot
dnf -y install certbot

# Generate a TLS certificate using certbot and validate the ACME challenge
certbot certonly --webroot -w /usr/share/nginx/html -d paulpranshu.xyz -d helpdesk.paulpranshu.xyz -m paulpranshu@gmail.com --agree-tos

# Create a directory for the website
mkdir -pv /var/www/helpdesk.paulpranshu.xyz

# Create a access log directory for the website. 
mkdir -pv /var/log/nginx/helpdesk.paulpranshu.xyz

# Configure the nginx virtual host: /etc/nginx/conf.d/helpdesk.paulpranshu.xyz.conf
server {
  listen 443 ssl;
  server_name helpdesk.paulpranshu.xyz;
  root /var/www/helpdesk.paulpranshu.xyz/;
  index index.php index.html index.htm;
  
  access_log /var/log/nginx/helpdesk.paulpranshu.xyz/access.log;
  error_log /var/log/nginx/helpdesk.paulpranshu.xyz/error.log;
  
  ssl_certificate /etc/pki/tls/certs/helpdesk.paulpranshu.xyz.crt;
  ssl_certificate_key /etc/pki/tls/private/helpdesk.paulpranshu.xyz.key;
}

mkdir -p /var/www/helpdesk.paulpranshu.xyz

# Apply the httpd_sys_content_t tag on the root directory of the website
semanage fcontext -a -t httpd_sys_content_t "/var/www/helpdesk.paulpranshu.xyz(/.*)?"
restorecon -Rv /var/www/helpdesk.paulpranshu.xyz

# Create the log directories
mkdir /var/log/nginx/helpdesk.paulpranshu.xyz

# Add a sample content
echo "Content for helpdesk.paulpranshu.xyz" > /var/www/helpdesk.paulpranshu.xyz/index.html

cp -v cert.pem /etc/pki/tls/certs/helpdesk.paulpranshu.xyz.crt
cp -v privkey.pem /etc/pki/tls/private/helpdesk.paulpranshu.xyz.key

restorecon -Rrv /etc/pki/tls/certs/helpdesk.paulpranshu.xyz.crt
restorecon -Rrv /etc/pki/tls/private/helpdesk.paulpranshu.xyz.key

# Verify the nginx syntax
nginx -t

# Restart the service
systemctl restart nginx
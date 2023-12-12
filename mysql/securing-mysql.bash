# Securing MySQL

alter user 'pranshu'@'localhost' with max_updates_per_hour* 10;
# Other variables to use with mysql.
max_user_connections
max_connections_per_hour

alter user 'pranshu'@'localhost' account lock;

# Use a strong algorithm for the root account.


# Use my.cnf instead of CLI.
[client]
user=pranshu
password=strongpassword


# Use SSL
[mysqld]
ssl_ca=ca.pem
ssl_cert=server-cert.pem
ssl_key=server-key.pem
require_secure_transport=ON


# To create a user that requires SSL.
create user 'pranshu'@'localhost' identified by 'password' require ssl;

# Use a password validation plugin.
plugin-load-add=validate_password.so

# Set the password validation policy to high.
set global validate_password.policy=high;

# MySQL backup tools
mysqldump
mysqlpump

# Create users with an algorithm.
create user 'pranshu'@'localhost' identified with caching_sha2_password by 'password';
create user 'pranshu'@'localhost' identified with 'sha256_password' by 'password';

# Or set it as a default in my.cnf.
default_authentication_plugin = sha256_password
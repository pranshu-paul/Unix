# Installing a FreeIPA server.

# Set a static hostname for the server.
hostnamectl set-hostname srv.paulpranshu.org

# Launch the shell again.
exec -l bash

# Change the timezone of the server.
timedatectl set-timezone Asia/Kolkata

# Enable the module.
dnf -y module enable idm:DL1

# Install FreeIPA server with a DNS server.
dnf -y module install idm:DL1/{server,dns}

# For centos 9: dnf install freeipa-server ipa-server-dns -y

# IPv6 on loopback is required

# Configure the IPA server.
ipa-server-install \
--hostname srv.paulpranshu.org \
--realm paulpranshu.org \
--ds-password admin@123 \
--admin-password admin@123 \
--unattended \
--setup-dns \
--forwarder 67.207.67.3 \
--forwarder 67.207.67.2 \
--no-reverse

# To check the version installed.
ipa --version

# All to use the ipa commands.
kinit admin

## USER ##

# To create a new user.
ipa user-add client.paul \
--first=Pranshu \
--last=Paul \
--shell=/bin/bash \
--title=Support \
--password

# To change password.
ipa user-mod pranshu.paul --password

# To print the status of a user.
ipa user-status pranshu.paul

# To unlock a user after getting locked by multiple incorrect passwords.
ipa user-unlock pranshu.paul

# To delete a user.
ipa user-del pranshu

## GROUP ##

# To create a group.
ipa group-add techops.user

# To add a client.
ipa host-add --ip-address=192.168.166.31 client.paulpranshu.org

#### Client side #####
echo '10.122.0.3 client.paulpranshu.org client' >> /etc/hosts

hostnamectl set-hostname client.paulpranshu.org --static

exec -l bash

timedatectl set-timezone Asia/Kolkata

# Add a NameServer entry in the below file at the top.
vi /etc/resolv.conf
nameserver 10.122.0.2

dnf -y module install idm

# Verify that the IPA server hostname should e returned.
host -t SRV _kerberos._udp.paulpranshu.org
host -t SRV _ldap._tcp.paulpranshu.org

ipa-client-install --mkhomedir



# Host based access control #
# Disable the default hbac rules.
ipa hbacrule-disable allow_all

# Create a HBAC rule.
ipa hbacrule-add <rule_name>
ipa hbacrule-add dev

# Add the user in the rule.
ipa hbacrule-add-user --user=<username> <rule_name>
ipa hbacrule-add-user --users=client.paul dev

# Add a host in the rule.
ipa hbacrule-add-host --hosts=<client_dns> <rule_name>
ipa hbacrule-add-host --host=client.paulpranshu.org dev

# Add the services sshd & sudo in the rule.
ipa hbacrule-add-service --hbacsvcs=sshd <rule_name>
ipa hbacrule-add-service --hbacsvcs=sshd,sudo dev

# By default the users can login to any host.
ipa hbacrule-show allow_all
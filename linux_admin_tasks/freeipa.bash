# Installing a FreeIPA server.

# Set a static hostname for the server.
hostnamectl set-hostname srv.paulpranshu.org

# Launch the shell again.
exec -l bash

# Update the hosts file
vim /etc/hosts
10.0.0.207 srv.paulpranshu.org

# Update the lookup sequence. Remove myhostname
vi /etc/nsswitch.conf
hosts:      files dns

# Verify it should only return ipv4
getent hosts srv.paulpranshu.org

# Change the timezone of the server.
timedatectl set-timezone Asia/Kolkata

# Install FreeIPA server.
dnf -y install ipa-server

# For centos 9: dnf install freeipa-server ipa-server-dns -y

# IPv6 on loopback is required

# Ensure the umask set to 0022
umask 022

# Configure the IPA server.
ipa-server-install \
--hostname srv.paulpranshu.org \
--realm paulpranshu.org \
--ds-password admin@123 \
--admin-password admin@123 \
--unattended

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
ipa user-mod client.paul --password

# To print the status of a user.
ipa user-status client.paul

# To unlock a user after getting locked by multiple incorrect passwords.
ipa user-unlock client.paul

# To delete a user.
ipa user-del client.paul

## GROUP ##

# To create a group.
ipa group-add techops.user

# To add a client.
ipa host-add --ip-address=192.168.166.31 client.paulpranshu.org

# On the server side
# Do no update the file /etc/nsswitch manually
authselect select sssd --force
authselect enable-feature with-mkhomedir with-sudo
authselect enable-feature with-sudo
authselect apply-changes
systemctl restart sssd
systemctl enable --now oddjobd


#### Client side #####
echo '10.0.0.207 srv.paulpranshu.org' >> /etc/hosts

hostnamectl set-hostname client.paulpranshu.org --static

exec -l bash

timedatectl set-timezone Asia/Kolkata

# On the client side
dnf -y install ipa-client

# Install ipa client with mkhomedir option
ipa-client-install --server=srv.paulpranshu.org --domain=paulpranshu.org --mkhomedir

# Back on the server side
# Host based access control #
# Disable the default hbac rules.
ipa hbacrule-disable allow_all

# Create a HBAC rule.
ipa hbacrule-add <rule_name>
ipa hbacrule-add dev

# Add the user in the rule.
ipa hbacrule-add-user --users=client.paul dev

# Add a host in the rule.
ipa hbacrule-add-host dev --hosts=srv.paulpranshu.org

# Add the services sshd in the rule.
ipa hbacrule-add-service dev --hbacsvcs=sshd --hbacsvcs=sudo --hbacsvcs=sudo-i

# Restart the service and cache
sss_cache -E
systemctl restart sssd

# By default the users can login to any host.
ipa hbacrule-show allow_all

# To refresh teh sssd cache
sss_cache -E


# To allow sudo access
ipa sudocmd-add ALL --desc="Allow all commands"
ipa sudorule-add dev-sudo
ipa sudorule-add-user dev-sudo --users=client.paul
ipa sudorule-add-host dev-sudo --hosts=srv.paulpranshu.org
ipa sudorule-add-allow-command dev-sudo --sudocmds=ALL

# To allow sudo access without password
ipa sudorule-add-option dev-sudo --sudooption='!authenticate'
ipa sudorule-show dev-sudo --all

# Refresh the cache and restart the service
# Run the below command every time you make changes in the IPA server
sss_cache -E
systemctl restart sssd
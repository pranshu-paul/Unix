# MOUNTING A SAMBA CLIENT
*************************

# Packages required cifs-utils
dnf -y install cifs-utils

# Check in windows, file sharing is enabled in "Network and sharing centre"
# Usernames are case sensitive

# Instead of using the IP address we could make an entry in "/etc/hosts"
cat > /root/.smb_cred <<EOF
username=<username>
password=<password>
EOF

# Protect the file containing credentials from being read.
chmod 400 /root/.smb_cred

# Test the file system.
mount -t cifs -o username=<usernam> //<ip_address>/users /<mount_point>

# Add the below entry in /etc/fstab
//<ip_address>/users /<mount_point> cifs credentials=/root/.smb_cred 0 0

# Reload the daemons after updating /etc/fstab.
systemctl daemon-reload

# CONFIGURING A SAMBA SERVER and nmb (NetBIOS service)
******************************************************
dnf -y install samba.$(uname -m) nmb

# Create a folder (as a samba share)
mkdir /srv/smbshare

# Tell SELinux about the change.
semanage fcontext -a -t public_content_t "/srv/smbshare(/.*)?"
restorecon -Rv /srv/smbshare

# Change permissions and group membership of the directory.
chmod 770 /srv/smbshare
chgrp paul /srv/smbshare

# Create a custom folder for a new config.
mkdir /etc/samba/custom-config

# Add the details about the share created.
cat > /etc/samba/custom-config/smbshare.conf <<EOF
[smbshare]
comment = sambashare
read only = No
path = /srv/smbshare
EOF

# Add the "include" directive at the bottom of the file.
echo 'include /etc/samba/custom-config/smbshare.conf' >> /etc/samba/smb.conf

# Start and enable both the services.
systemctl enable --now smb
systemctl enable --now nmb

# Allow the both services on firewall.
firewall-cmd --add-port={139,445}/tcp --permanent # For Samba
firewall-cmd --add-port={137,138}/udp --permanent # Nmb service

# Set password and add the user as the allowed user for samba.
smbpasswd -a paul
smbpasswd -e paul

# Test the samba configuration from the below command.
testparm -s /etc/samba/custom-config/smbshare.conf

# Restart smb service to reflect the changes.
smbcontrol all reload-config
systemctl restart smb

# Open the run prompt by pressing win + r key on your keyboard.
Then type \\<server_ip_address> and press enter key.

# While mapping the network drive.
\\<server_ip_address>\<user>
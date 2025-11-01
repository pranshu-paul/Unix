# MOUNTING A SAMBA CLIENT on RHEL 9.x

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


#####################################################
# CONFIGURING A SAMBA SERVER on RHEL 9.x
dnf -y install samba

# Create a folder (as a samba share)
mkdir /srv/smbshare

# Tell SELinux about the change.
semanage fcontext -a -t samba_share_t "/srv/smbshare(/.*)?"
restorecon -Rv /srv/smbshare

# Enable selinux boolean for the user home directories.
setsebool -P samba_enable_home_dirs on

# Change permissions and group membership of the directory.
chmod 770 /srv/smbshare
chown admin:admin /srv/smbshare


# Add the details about the share created.
# The name between the square brakets will be the sharename
cat >> /etc/samba/smb.conf <<EOF

[myshare]
	comment = My Share
	path = /srv/smbshare/
	browseable = yes
	writable = yes
	valid users = admin
	read only = no
EOF

# Start and enable the service.
systemctl enable --now smb

# Allow the both services on firewall.
firewall-cmd --add-port={139,445}/tcp --permanent # For Samba

# Set password and add the user as the allowed user for samba.
smbpasswd -a admin
smbpasswd -e admin

# Test the samba configuration from the below command.
testparm

# Restart smb service to reflect the changes.
smbcontrol all reload-config
systemctl restart smb

# Check and list the available shares. And use the password provided during the smbpasswd cmd.
smbclient -L localhost -U admin

# Open the run prompt by pressing win + r key on your keyboard.
# Then type \\<server_ip_address> and press enter key.

# While mapping the network drive.
\\<server_ip_address>\<share>

# If the connections get hanged, delete them.
net use * /delete
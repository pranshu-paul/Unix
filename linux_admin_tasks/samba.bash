MOUNTING A SAMBA CLIENT

Packages required cifs-utils

Check in windows, file sharing is enabled in "Network and sharing centre"
Usernames are case sensitive

Instead of using the IP address we could make an entry in "/etc/hosts"

mount -t cifs -o username=<usernam> //<ip_address>/users /<mount_point>

cat > /etc/samba-credentials <<EOF
username=<username>
password=<password>
defaults # Options
EOF

chmod 600 /etc/samba-credentials

//<ip_address>/users /<mount_point> cifs credentials=/etc/samba-credentials 0 0

# CONFIGURING A SAMBA SERVER and nmb (NetBIOS service)
dnf -y install samba.$(uname -m) nmb

mkdir /srv/smbshare

semanage fcontext -a -t public_content_t "/srv/smbshare(/.*)?"

restorecon -Rv /srv/smbshare

chmod 770 /srv/smbshare

chgrp paul /srv/smbshare

mkdir /etc/samba/custom-config

cat > /etc/samba/custom-config/smbshare.conf <<EOF
[smbshare]
comment = sambashare
read only = No
path = /srv/smbshare
EOF

echo 'include /etc/samba/custom-config/smbshare.conf' >> /etc/samba/smb.conf

systemctl enable --now smb
systemctl enable --now nmb

firewall-cmd --add-port={139,445}/tcp --permanent # For Samba
firewall-cmd --add-port={137,138}/udp --permanent # Nmb service

smbpasswd -a paul

smbpasswd -e paul

testparm -s /etc/samba/custom-config/smbshare.conf

smbcontrol all reload-config
systemctl restart smb

Run prompt by pressing win + r key on your keyboard
Then type \\<server_ip_address> and press enter key.

While mapping the network drive.
\\<server_ip_address>\<user>
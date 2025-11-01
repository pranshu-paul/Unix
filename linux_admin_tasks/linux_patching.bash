# Creating a Local mirror to install the latest security patches

# Create a VM with a separate disk of at least 250GB
# vCPU: 8
# Memory: 8gb
# Internet access is required

# Sync the Oracle baseos latest repository arch: x86_64, i686, .noarch.
# Excluse source codes
# Use nohup
reposync --repoid ol8_baseos_latest -p /data01/repos --download-metadata --exclude *.src

# Sync the Oracle Unbreakable Enterprise Kernel Repository v7. arch: x86_64, i686, .noarch.
# Use nohup
reposync --repoid ol8_UEKR7 -p /data01/repos --download-metadata --exclude *.src

# Sync the Oracle appstream. arch: x86_64, i686, .noarch.
# Use nohup
reposync --repoid ol8_appstream -p /data01/repos --download-metadata --exclude *.src


# Configure Apache web server.
dnf -y install httpd

# Set SElinux to permissive mode.
vim /etc/selinux/config
SELINUX=permissive

setenforce 0

# Create a virtual host.

Listen 8080
<VirtualHost *:8080>

        DocumentRoot "/data01"
        ServerName mirror
        CustomLog /var/log/httpd/data_access.log combined
        ErrorLog /var/log/httpd/data_srv_error.log

        <Directory "/data01">
                Options Indexes FollowSymLinks
                Allowoverride none
                Require all granted
        </Directory>

</VirtualHost>

# Check the configuration syntax.
apachectl configtest

# Start web server
systemctl start httpd


dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

cp -v /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8 /data01/rpm-gpg

# Sync the fedora epel. arch: x86_64, i686, .noarch.
# Use nohup
reposync --repoid epel -p /data01/repos --download-metadata --exclude *.src

===============================================================================================
# To autosync the mirror
#!/bin/bash

repo=/data01/repos

reposync --repoid ol8_baseos_latest -p "$repo" --download-metadata --exclude *.src

reposync --repoid ol8_UEKR7 -p "$repo" --download-metadata --exclude *.src

reposync --repoid ol8_appstream -p "$repo" --download-metadata --exclude *.src

reposync --repoid epel -p "$repo" --download-metadata --exclude *.src
===============================================================================================


Preparing the target before patching
************************************

# Take a config snapshot use the "fetch_config" script.

# Take snapshot using the vcenter

# Take a reboot before.
shutdown -r now

# Check for any exceptions
journalctl -r -k -o short -n 15 --no-pager
dmesg --decode -e | grep -E ':warn|:crit|:err|segfault'

# Update the repos
mv -v /etc/yum.repos.d/oracle-linux-ol8.repo{,.bak}
mv -v /etc/yum.repos.d/uek-ol8.repo{,.bak}
mv -v /etc/yum.repos.d/epel.repo{,.bak}
mv -v /etc/yum.repos.d/oel_local.repo{,.bak}

# Clean metadata
dnf clean metadata

# Import the GPG key of the epel repository.
curl -s http://172.19.8.192:8080/rpm-gpg/RPM-GPG-KEY-EPEL-8 > /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8

Create or update the yum client.
vim /etc/yum.repos.d/oracle-linux.repo

[ol8_baseos_latest]
name=Oracle Linux 8 BaseOS Latest ($basearch)
baseurl=http://172.19.8.192:8080/repos/ol8_baseos_latest
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

[ol8_appstream]
name=Oracle Linux 8 Application Stream ($basearch)
baseurl=http://172.19.8.192:8080/repos/ol8_appstream
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

[ol8_UEKR7]
name=Latest Unbreakable Enterprise Kernel Release 7 for Oracle Linux $releasever ($basearch)
baseurl=http://172.19.8.192:8080/repos/ol8_UEKR7
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

[epel]
name=Extra Packages for Enterprise Linux 8 - x86_64
baseurl=http://172.19.8.192:8080/repos/epel
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8

# Clean the metadata
dnf clean metadata

# Set dnf metadata cache to expire everytime.
vim /etc/dnf/dnf.conf
metadata_expire=0

Applying Patches
****************

# Check update
dnf check-update --security --exclude *.src

# First dry run the below command to check whether the patches can be applied in a single go.
dnf --assumeno update-minimal --security

# If not, then apply the patches in the below mentioned order.
First apply the latest patches of kernel and linux-firmware of the below packages.
core_packages=(
kernel
kernel-headers
kernel-core
kernel-modules
kernel-tools
kernel-tools-libs
linux-firmware
linux-firmware-core
kernel-uek
kernel-uek-core
kernel-uek-modules
)

# Dry run the core packages.
dnf --assumeno update-minimal --security ${core_packages[@]}
	
# If normal, apply
dnf -y update-minimal --security ${core_packages[@]}


# Take a reboot
shutdown -r now

sys_packages=(
shim-x64
grub2-efi-x64
glibc
libgcc
libstdc++
systemd
dbus
udev
dracut
lvm2
xfsprogs
iproute
NetworkManager
util-linux
shadow-utils
bash
openssh
openssh-server
ncurses
pam
openssl
rpm
microcode_ctl
open-vm-tools
yum
dnf
sudo
procps-ng
dmidecode
firewalld
)

# First verify the packages
dnf --assumeno update-minimal --security ${sys_packages[@]}

dnf -y update-minimal --security ${sys_packages[@]}

# Check for the sys packages need reboot
dnf needs-restarting -r

# Take a reboot
shutdown -r now

# If GUI is installed
gui_packages=(
gnome-shell
firefox
xorg-x11-server-Xorg
xorg-x11-server-Xwayland
xorg-x11-server-common
gnome-desktop3
)

# Apply the latest security patches only no bugfix or enahcements to kernel
dnf --assumeno update-minimal --security ${gui_packages[@]}

dnf -y update-minimal --security ${gui_packages[@]}

Identify the security patches for the below packages if found.
httpd
nginx
php
mysql
redis
mongodb
glibc-devel
cpp
node
npm

Get an approval for them.


# Update sssd and IPA related packages.
dnf --assumeno update-minimal --security python3-sssdconfig
dnf -y update-minimal --security python3-sssdconfig

Apply the latest security patches.
# Verify the updates available
dnf --assumeno update-minimal --security

# If all the above mentioned patches are applied successfuly.
# Apply the remaining patch updates.
dnf -y update-minimal --security

# Update the OS minor version in /etc/system-release /etc/redhat-release files 
dnf -y update oraclelinux-release

# Check which packages needs reboot.
dnf needs-restarting -r

# Reboot the server
shutdown -r now

# Recheck updates
dnf check-update --security --exclude *.src

# Cleanup
dnf --assumeno autoremove
dnf -y autoremove

# Check which packages needs reboot.
dnf needs-restarting -r

# Reboot
shutdown -r now


# Verify the integrity of the local rpms
dnf check
dnf repoquery --unsatisfied

# Restore the repos.
mv -v /etc/yum.repos.d/oel_local.repo.bak /etc/yum.repos.d/oel_local.repo
mv -v /etc/yum.repos.d/oracle-linux.repo{,.bak}

# Change the oel_local repo to ol-810

# Remove symantec.
/usr/lib/symantec/uninstall.sh -u ALL
# Clean metadata
dnf clean metadata
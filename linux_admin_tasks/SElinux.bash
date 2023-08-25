All processes and files are labled with SElinux label.
SElinux is system wide.
Implements MAC(Mandatory Access Control).
SELinux decisions are known as the Access Vector Cache (AVC).

dnf -y install setools-console setroubleshoot-server setroubleshoot

# This is a small guide for selinux.
Configuration files - /etc/selinux/config symbolic linked to /etc/sysconfig/selinux

# Important tools required to manage selinux.
yum -y install setroubleshoot setroubleshoot-server
policycoreutils-python-utils -- For EL8
policycoreutils-python -- EL7

# Restart auditd after installing setroubleshoot-server.
systemctl stop auditd;systemctl start auditd

# SElinux commands
sestatus, getenforce, semanage, chcon, restorecon, getsebool -a, setsebool, sealert, seinfo, sesearch

# Other command to use selinux.
ps -axZ, ss -nutlnpZ, id -Z, journalctl

# To restore any context.
restorecon -vR /path/to/file or directory

# If need to relable entire system.
# First set selinux to permisive mode.
# Then create this file in root node, then reboot.
touch /.autorelabel

# To check logs for selinux.
journalctl -t setroubleshoot
journalctl -r -t sealert

# To search for logs about selinux.
ausearch -m avc,AVC,USER_AVC,SELINUX_ERR
aureport -a

# To find correct context for a directory and file.
matchpathcon -V

# To get the list of labels for a service.
seinfo --type | grep <service_name>
seinfo --type | grep http
seinfo --type | grep nfs

# Kernel parameters at boot time.
# To force auto relable system.
autorelabel=1

# To boot in enforcing mode.
enforcing=0

# Avoid kernel to load any part of selinux.
selinux=0


sealert -a /var/log/audit/audit.log

ausearch -m avc

grep 'SELinux is preventing' /var/log/messages
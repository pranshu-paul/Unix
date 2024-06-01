#!/bin/bash

log_file=/home/$SUDO_USER/out_$(basename $0)_$(date +%d_%b).log

exec &>> ${log_file}

# Date and time when the script is running.
echo -e "Date and time when the script is running."
date

# Get the hostname, OS version, and kernel version.
echo -e "\nHostname, OS version, CPU architecture, and kernel version."
hostnamectl

# Network Configuration for each NIC.
echo -e "\nNICs breifing."
ip -4 -br addr show

# Number of CPU(s), Socket(s), and Core(s) per socket.
echo -e "\nNumber of CPU(s), Socket(s), and Core(s) per socket."
lscpu | grep -E '^CPU\(s\)|Socket|Core\(s\)'

# Total and free memory available.
echo -e "\nFree memory available."
free -hw

# Uptime and load average
echo -e "\nUptime and load average."
uptime

# System last reboot.
echo -e "\nSystem last five reboots"
last reboot -n 5

# Last failed logins.
echo -e "\nLast failed logins"
sudo lastb -n 10

# Hosts table.
echo -e "\nHost entries in the /etc/hosts file."
getent hosts | column -t -N IP,Hostname,FQDN,HostnameAlias,FQDN_Alias

# Which users can login locally.
echo -e "\nUsers that can login locally."
getent passwd | grep bash$ | column -s : -t -N User,Password,UID,GID,Description,Home,Shell

# Which users are in the wheel group.
echo -e "\nUsers that are in the wheel group."
getent group wheel | column -s : -t -N Group,Password,GID,Members

# Password expiry related directives.
echo -e "\nCurrent password ageing paramaters"
grep ^PASS /etc/login.defs

# Current systems password policies.
echo -e "\nCurrent password quality set."
grep -r pam_pwquality /etc/pam.d/* | column -t -s : -N File,Output

# Current applied switch user policy.
echo -e "\nCurrent applied su policy."
grep pam_wheel /etc/pam.d/su | sed '/^#/d' | column -t

# Which users are through domain.
domain_name=$(realm list | grep -w 'domain-name:' | awk '{print $2}')

if [ -n ${domain_name} ]; then
	users=($(realm list  | grep -w permitted-logins: | cut -d ' ' -f 4-))
	echo -e "\nUsers that can login through the domain."
	echo ${users[@]}	
fi

# List only the user installed packages.
echo -e "\nUser installed packages."
rpm --last -q $(dnf history userinstalled | sed '1d') | column -t

# DNS servers
echo -e "\nDNS servers available."
grep -vE '^#|^;' /etc/resolv.conf

# Time servers
echo -e "\nTime servers."
grep -i '^server' /etc/chrony.conf

# Cron jobs by user
echo -e "\nCron jobs scheduled by the users."
users=($(sudo ls /var/spool/cron))

for user in ${users[@]}; do
	echo -e "\nCronjobs of the user ${user}"
	sudo cat  /var/spool/cron/${user}
done

# Mount points with their file system time.
echo -e "\nFile system with inodes."
export FIELD_LIST=source,fstype,itotal,iused,iavail,ipcent,size,used,avail,pcent,file,target
df -h --output=$FIELD_LIST --total

# Print the physical volumes.
echo -e "\nPhysical volumes"
sudo pvdisplay

# Print the volume groups.
echo -e "\nVolumes groups and physical volumes in a group."
sudo vgdisplay

# Print the logical volumes
echo -e "\nLogical volumes on a volume group."
sudo lvdisplay

# /etc/fstab
echo -e "\nCurrent File system table."
grep -vE '^#|^$' /etc/fstab | column -t -N DEVICE_NAME,MOUNT_POINT,FILE_SYSTEM,OPTIONS,DUMP,PASS

# Application / Database directories
# To check the mount options applied.
echo -e "\nSpecific directories with their mount options."
mount_options() {
mount | grep "$1" | column -t -N Device,_,MountPoint,_,FileSystem,Options
}

mount_options app01
mount_options data01

# ACLs on the specific directories.
echo -e "\nACL on the specific directories."
find / -maxdepth 1 -name data01 -type d -exec getfacl {} -p \;
find / -maxdepth 1 -name app01 -type d -exec getfacl {} -p \;

# Applied sshd configuration.
echo -e "\nCurrent sshd_config"
sudo grep -vE '^#|^$' /etc/ssh/sshd_config

# Current tuned profile.
echo -e "\nCurrent active tuned profile."
tuned-adm active

# Kernel Parameters.
echo -e "\nCurrent kernel parameters"
grep -vE '^#|^$' /etc/sysctl.conf

echo -e "\nKernel parameters in the sysctl.d directory."
cat /etc/sysctl.d/* | grep -vE '^#|^$'

echo -e "\nKernel parameters in the /usr/lib/sysctl.d directory."
cat /usr/lib/sysctl.d/* | grep -vE '^#|^$'

echo -e "\nCurrent sudoers directives."
grep -vE '^#|^$' /etc/sudoers

echo -e "\nCurrent sudoers directives in the /etc/sudoers.d directory."
grep -vE '^#|^$' /etc/sudoers.d/*

# ulmits
echo -e "\nApplied OS limits."
grep -vE '^#|^$'  /etc/security/limits.conf

echo -e "\nApplied OS limits in the /etc/security/limits.d directory."
grep -r -vE '^#|^$' /etc/security/limits.d

# Firewall state
echo -e "\nFirewall state"
systemctl is-active firewalld

# SElinux status
echo -e "\nSElinux status."
getenforce

# Main routing table.
echo -e "\nKernel routing table"
ip route show

echo -e "\nNICs and their configs"
ip -br link show

echo -e "\nNICs with their gateways and routes"
nmcli -p -f general,ip4 device show | cat

echo -e "\nNo. of established connection of processes."
sudo ss -Hntup state established | cut -d '"' -f 2 |  sort | uniq -c | sort -nr | column -t -N EstabCount,Process

# Enabled repos.
echo -e "\nEnabled repos"
yum repolist --enabled

# Check whether GUI is enabled or not.
echo -e "\nCheck the GDM service."
systemctl is-active gdm

# Check the default target.
echo -e "\nCheck the default target"
systemctl get-default

# Services running.
echo -e "\nCurrently runnning services."
systemctl list-units --type=service --state=running | cat

# Units disabled.
echo -e "\nCurrently disabled services."
systemctl list-unit-files --state=disabled | cat

# What processes are running other than root.
echo -e "\nProcesses running other than root sorted by %CPU."
export PS_FORMAT="ruser:20,pid,ppid,nice,wchan:25,pmem,pcpu,time:15,euser:20,stat,flags,stime,thcount,comm:25"
ps -e --sort=-pcpu | grep -v root

echo -e "\nBusiness specific processes sorted by %CPU."
export PS_FORMAT="ruser:20,pid,ppid,nice,wchan:25,pmem,pcpu,time:15,euser:20,stat,flags,stime,thcount,comm:25"
ps -e --sort=-pcpu | grep -E 'ksmppd|bearerbox|sqlbox|gluster|mysqld' | column -t -N RUSER,PID,PPID,NICE,WCHAN,PMEM,PCPU,TIME,EUSER,STAT,FLAGS,STIME,THCOUNT,COMM

# Which sockets are listening.
echo -e "\nSockets that are listening."
sudo ss -lntup

# Any third party softwares installed.
echo -e "\nAny third party softwares installed."
ls /opt
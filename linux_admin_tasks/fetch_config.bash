#!/bin/bash

# Only for EL 8

print_header() {
    echo -e "\n=============================================================================================================================================="
    echo  " 				$1 "
    echo -e "==============================================================================================================================================\n"
}

log_file=/tmp/out_$(basename $0)_$(date +%d_%b).log

# exec &>> ${log_file}

# Date and time when the script is running.
print_header "Date and time when the script is running."
date

# Get the hostname, OS version, and kernel version.
print_header "Hostname, OS version, CPU architecture, and kernel version."
hostnamectl

# Network Configuration for each NIC.
print_header "NICs breifing."
ip -4 -br addr show | cut -d '/' -f 1 | grep -w UP | awk '{print $1 "\t" $3}'| column -t -N NIC,IP

# Number of CPU(s), Socket(s), and Core(s) per socket.
print_header "Number of CPU(s), Socket(s), and Core(s) per socket."
lscpu | grep -E '^CPU\(s\)|Socket|Core\(s\)'

# Total and free memory available.
print_header "Free memory available."
free -hw

# Uptime and load average
print_header "Uptime and load average."
uptime

# System last reboot.
print_header "System last five reboots"
last reboot -n 5

# Last failed logins.
print_header "Last failed logins"
sudo lastb -n 10

systemctl list-units --state=failed --all --no-pager

# Hosts table.
print_header "Host entries in the /etc/hosts file."
getent hosts | column -t -N IP,Hostname,FQDN,HostnameAlias,FQDN_Alias

# Which users can login locally.
print_header "Users that can login locally."
getent passwd | grep bash$ | column -s : -t -N User,Password,UID,GID,Description,Home,Shell

# Which users are in the wheel group.
print_header "Users that are in the wheel group."
getent group wheel | column -s : -t -N Group,Password,GID,Members

# Password expiry related directives.
print_header "Current password ageing paramaters"
grep ^PASS /etc/login.defs

# Current systems password policies.
print_header "Current password quality set."
grep -r pam_pwquality /etc/pam.d/* | column -t -s : -N File,Output

# Current applied switch user policy.
print_header "Current applied su policy."
grep pam_wheel /etc/pam.d/su | sed '/^#/d' | column -t

# Which users are through domain.
domain_name=$(realm list | grep -w 'domain-name:' | awk '{print $2}')

print_header " Users that can login through the domain "

if [ -n ${domain_name} ]; then
	users=($(realm list  | grep -w permitted-logins: | cut -d ' ' -f 4-))
	echo ${users[@]}	
fi

# List only the user installed packages.
print_header "User installed packages."
rpm --last -q $(dnf history userinstalled | sed '1d') | column -t -N Package,Day,Date,Mon,Year,Time,Period,TZ

# DNS servers
print_header "DNS servers "
grep -vE '^#|^;' /etc/resolv.conf | grep nameserver | awk '{print $2}' | column -t -N NameServer

# Time servers
print_header "Time servers."
chronyc sources | grep -w '\^\*' | awk '{print $2}' | column -t -N TimeServer

# Cron jobs by user
print_header "Cron jobs scheduled by the users."
users=($(sudo ls /var/spool/cron))

for user in ${users[@]}; do
	echo -e "Cronjobs of the user ${user}"
	sudo cat  /var/spool/cron/${user}
done

# Mount points with their file system time.
print_header "File system with inodes."
export FIELD_LIST=source,fstype,itotal,iused,iavail,ipcent,size,used,avail,pcent,file,target
df -h --output=$FIELD_LIST --total

# Print the physical volumes.
print_header "Physical volumes"
sudo pvdisplay

# Print the volume groups.
print_header "Volumes groups and physical volumes in a group."
sudo vgdisplay

# Print the logical volumes
print_header "Logical volumes on a volume group."
sudo lvdisplay

# /etc/fstab
print_header "Current File system table."
grep -vE '^#|^$' /etc/fstab | column -t -N DEVICE_NAME,MOUNT_POINT,FILE_SYSTEM,OPTIONS,DUMP,PASS

print_header " Paritions "
lsblk -lpfm

# Application / Database directories
# To check the mount options applied.
print_header "Specific directories with their mount options."
mount_options() {
mount | grep "$1" | column -t -N Device,_,MountPoint,_,FileSystem,Options
}

mount_options app01
mount_options data01

# ACLs on the specific directories.
print_header "ACL on the specific directories."
find / -maxdepth 1 -name data01 -type d -exec getfacl {} -p \;
find / -maxdepth 1 -name app01 -type d -exec getfacl {} -p \;

# Applied sshd configuration.
print_header "Current sshd_config"
sudo grep -vE '^#|^$' /etc/ssh/sshd_config

# Current tuned profile.
print_header "Current active tuned profile."
tuned-adm active

# Kernel Parameters.
print_header "Current kernel parameters"
grep -vE '^#|^$' /etc/sysctl.conf

print_header "Kernel parameters in the sysctl.d directory."
cat /etc/sysctl.d/* | grep -vE '^#|^$'

print_header "Kernel parameters in the /usr/lib/sysctl.d directory."
cat /usr/lib/sysctl.d/* | grep -vE '^#|^$'

print_header "Current sudoers directives."
grep -vE '^#|^$' /etc/sudoers

print_header "Current sudoers directives in the /etc/sudoers.d directory."
 grep -rvE '^#|^$' /etc/sudoers.d

# ulmits
print_header "Applied OS limits."
grep -vE '^#|^$'  /etc/security/limits.conf

print_header "Applied OS limits in the /etc/security/limits.d directory."
grep -r -vE '^#|^$' /etc/security/limits.d

# Firewall state
print_header "Firewall state"
systemctl is-active firewalld

# SElinux status
print_header "SElinux status."
getenforce

# Main routing table.
print_header "Kernel routing table"
ip route show

print_header "NICs and their configs"
ip -br link show

print_header "NICs with their gateways and routes"
#nmcli -p -f general,ip4 device show | cat
nmcli -p -f ip4 device show | cat

print_header "No. of established connection of processes."
sudo ss -Hntup state established | cut -d '"' -f 2 |  sort | uniq -c | sort -nr | column -t -N EstabCount,Process

# Enabled repos.
print_header "Enabled repos"
yum repolist --enabled

# Check whether GUI is enabled or not.
print_header "Check the GDM service."
systemctl is-active gdm

# Check the default target.
print_header "Check the default target"
systemctl get-default

# Services running.
print_header "Currently runnning services."
systemctl list-units --type=service --state=running | cat

# Units disabled.
print_header "Currently disabled services."
systemctl list-unit-files --state=disabled | cat

# What processes are running other than root.
print_header "Processes running other than root sorted by %CPU."
export PS_FORMAT="ruser:20,pid,ppid,nice,wchan:25,pmem,pcpu,time:15,euser:20,stat,flags,stime,thcount,comm:25"
ps -e --sort=-pcpu | grep -v root

print_header "Business specific processes sorted by %CPU."
export PS_FORMAT="ruser:20,pid,ppid,nice,wchan:25,pmem,pcpu,time:15,euser:20,stat,flags,stime,thcount,comm:25"
ps -e | head -1; ps -e | grep -v ps | grep -wE 'ksmppd|bearerbox|sqlbox|gluster?d?f?s?d?|mysqld|redis-server|node|mongod|ora_smon_nexgol|screen'

# Which sockets are listening.
print_header "Sockets that are listening."
sudo ss -lntup

# Any third party softwares installed.
print_header "Any third party softwares installed."
ls /opt

# Check if the system needs restarting
print_header " Reboot Required "
if rpm --quiet -q yum-utils; then
	needs-restarting -r
fi

print_header " Services Require Restart "
if rpm --quiet -q yum-utils; then
	sudo needs-restarting -s
fi


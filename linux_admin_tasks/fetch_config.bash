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
sudo lastb

# Hosts table.
echo -e "\nHost entries in the /etc/hosts file."
getent hosts

# Which users can login locally.
echo -e "\nUsers that can login locally."
getent passwd | grep sh$

# Which users are in the wheel group.
echo -e "\nUsers that are in the wheel group."
getent group wheel

# Password expiry related directives.
echo -e "\nCurrent password ageing paramaters"
grep ^PASS /etc/login.defs

# Current systems password policies.
echo -e "\nCurrent password quality set."
grep pam_pwquality /etc/pam.d/*  | column -t

# Which users are through domain.
domain_name=$(realm list | grep -w 'domain-name:' | awk '{print $2}')

if [[ -n ${domain_name} ]]
then
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
chronyc sources | grep '^\^\*'

# Cron jobs by user
echo -e "\nCron jobs scheduled by the users."
users=($(sudo ls /var/spool/cron))

for user in ${users[@]}; do
	echo -e "\nCronjobs of user ${user}"
	sudo cat  /var/spool/cron/${user}
done

# Mount points with their file system time
echo -e "\nMount with their file system and total storage."
df -hT --total

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
grep -vE '^#|^$' /etc/fstab | column -t

# Application / Database directories
# To check the mount options applied.
mount | grep app01

mount | grep data01

# Applied sshd configuration.
echo -e "\nCurrent sshd_config"
sudo grep -vE '^#|^$' /etc/ssh/sshd_config

# Applied sshd configuration in the /etc/ssh/ssh_config.d directory.
echo -e "\nCurrent sshd_config in the /etc/ssh/ssh_config.d directory"
sudo grep -vE '^#|^$' /etc/ssh/ssh_config.d/*

# Kernel Parameters.
echo -e "\nCurrent kernel parameters"
grep -vE '^#|^$' /etc/sysctl.conf

echo -e "\nKernel parameters in the sysctl.d directory."
cat /etc/sysctl.d/* | grep -vE '^#|^$'

echo -e "\nKernel parameters in the /usr/lib/sysctl.d directory."
cat /usr/lib/sysctl.d/* | grep -vE '^#|^$'

# ulmits
echo -e "\nApplied OS limits."
grep -vE '^#|^$'  /etc/security/limits.conf

# Firewall state
echo -e "\nFirewall state"
systemctl is-active firewalld

# SElinux status
echo -e "\nSElinux status."
sestatus

# Main routing table.
echo -e "\nKernel routing table"
ip route show

echo -e "\nNICs and their configs"
ip addr show

echo -e "\nNICs with their gateways and routes"
nmcli dev show | cat

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
echo -e "\nProcesses running other than root."
ps -eo pid,ppid,cmd,pmem,pcpu,user,time,euser,stat,flags,stime,wchan --sort=-pcpu | grep -v root

# Which sockets are listening.
echo -e "\nSockets that are listening."
sudo ss -lntup

# Any third party softwares installed.
echo -e "\nAny third party softwares installed."
ls /opt
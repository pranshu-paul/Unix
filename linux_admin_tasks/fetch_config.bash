#!/bin/bash

log_file=out_$(basename $0)_$(date +%d_%b).log

exec &>> ${log_file}

# Date and time when the script is running.
echo -e "Date and time when the script is running."
date

# Get the hostname, OS version, and kernel version.
echo -e "\nHostname, OS version, CPU architecture, and kernel version."
hostnamectl

# Number of cores.
echo -e "\nNumber of cores available."
nproc

# Total and free memory available.
echo -e "\nFree memory available."
free -h

# Uptime and load average
echo -e "\nUptime and load average."
uptime

# Hosts table.
echo -e "\nHost entries in the /etc/hosts file."
getent hosts

# Which users can login locally.
echo -e "\nUsers that can login locally."
getent passwd | grep sh$

# Which users are in the wheel group.
echo -e "\nUsers that are in the wheel group."
getent group wheel

# Is the server connected to a domain.
realm list | grep -w 'domain-name:' | awk '{print $2}'


# Which users are through domain.
domain_name=$(realm list | grep -w 'domain-name:' | awk '{print $2}')

if [[ -n ${domain_name} ]]; then
	echo -e "\nUsers that can login through the domain."
	users=$(realm list  | grep -w permitted-logins: | cut -d ' ' -f 4-)
	echo ${users}
fi

# List only the user installed packages.
echo -e "\nUser installed packages."
dnf history userinstalled

# DNS servers
echo -e "\nDNS servers available."
grep -vE '^#|^;' /etc/resolv.conf

# Time servers
echo -e "\nTime servers."
chronyc sources

# Cron jobs by user
echo -e "\nCron jobs scheduled by the users."
users=($(sudo ls /var/spool/cron))

for user in ${users[@]}; do
	echo -e "\nCronjobs of user ${user}"
	cat  /var/spool/cron/${user}
done

# Mount points with their file system time
echo -e "\nMount with their file system and total storage."
df -hT --total

# /etc/fstab
echo -e "\nCurrent File system table."
grep -vE '^#|^$' /etc/fstab | column -t

# Application / Database directories


# Applied sshd configuration.
echo -e "\nCurrent sshd_config"
sudo grep -vE '^#|^$' /etc/ssh/sshd_config

# Kernel Parameters.
echo -e "\nCurrent kernel parameters"
grep -vE '^#|^$' /etc/sysctl.conf

echo -e "\nKernel parameters in the sysctl.d directory."
cat /etc/sysctl.d/* | grep -vE '^#|^$'

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

# Network Configuration for each NIC.
echo -e "\nNICs breifing."
ip -4 -br addr show

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
ps aux | grep -v ^root

# Which sockets are listening.
echo -e "\nSockets that are listening."
sudo ss -lntup

# Any third party softwares installed.
echo -e "\nAny third party softwares installed."
ls /opt
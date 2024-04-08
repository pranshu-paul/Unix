# Set the session timeout.
echo 'export TMOUT=600' > /etc/profile.d/tmout.sh

# Set timout of the SSH connections.
ClientAliveInterval 300
ClientAliveCountMax 0

# Disable IPv6.
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# Disable IP forwarding.
net.ipv4.ip_forward = 0

# Disable packet forwards.
net.ipv4.conf.all.send_redirects = 0


# Define password policies in the login.defs file.


# Disable coredump of a storage in /etc/systemd/coredump.conf.
Storage=none

#  Ensure core dump backtraces /etc/systemd/coredump.conf
ProcessSizeMax=0

# Define passowrd policies using the pam modules.
pam_cracklib

# Set password aging.

# Harden the SSH service
Use a non-standard port
Disable root login
Limit user access
Use key-pair authentication
Limit the number of authentication attempts

# Remove the leagacy services

# Stop unnecessary services.

# Set password quality in /etc/security/pwquality.conf

# Set password authentication tries.

# Enable a firewall

# Ensure that nftables is installed as the only back-end of firewall-cmd

# Enable SElinux

# Disable the unwanted linux services

# Disable the unnecessary cron jobs.

# Stop the unnecessary ports listening

# Keep the system minimal

# Disable Ctrl+Alt+Delete

# Remove unwanted SUID and SGID binaries to avoid privilege escalation attack

# Take a backup of /etc/passwd and /etc/shadow

# Black list non-required modules.

# Use pam_faillock or fail2ban to protect from brute force.


# Check which user does not have a password.
/bin/cat /etc/shadow | /bin/awk -F: '($2 == "" ) { print $1 " does not have a password "}'

# Avoid SYN floods at the kernel level.
net.ipv4.tcp_syncookies = 1

# Ensure the permissions and ownership of the crontab files

# Ensure the "su" command is restricted.

# Ensure root is the only 0 UID account.
awk -F: '($3 == 0) { print $1 }' /etc/passwd


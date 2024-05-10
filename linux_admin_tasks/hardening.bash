# Hardening and system auditing

# Audit
grep TMOUT /etc/profile /etc/bashrc /etc/profile.d/*

# Set the session timeout.
echo 'readonly TMOUT=3600; export TMOUT' > /etc/profile.d/tmout.sh

# Set a local terminal warning before the users login.
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

# Audit.
grep -o 'ipv6.disable=[0,1]' /boot/efi/EFI/centos/grubenv

for file in /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf
do
	grep disable_ipv6 ${file}
done

sysctl -a --pattern disable_ipv6

# Disable IPv6.
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/10-np-custom.conf
sysctl -w net.ipv6.conf.all.disable_ipv6=1

# To disable a specific interface.
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/10-np-custom.conf
sysctl -w net.ipv6.conf.default.disable_ipv6=1

echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.d/10-np-custom.conf
sysctl -w net.ipv6.conf.lo.disable_ipv6=1

# Disable IP forwarding.
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/10-np-custom.conf
sysctl -w net.ipv4.ip_forward=0

# Disable packet forwards.
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.d/10-np-custom.conf

# Audit
for file in /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf
do
	grep send_redirects ${file}
done

sysctl -a --pattern net.ipv4.conf.all.send_redirects

# Avoid SYN floods at the kernel level.
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/10-np-custom.conf

# Audit
for file in /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf
do
	grep tcp_syncookies ${file}
done

sysctl -a --pattern net.ipv4.tcp_syncookies

# Define password policies in the login.defs file.

PASS_MAX_DAYS   35
chage --maxdays <days> <user> # For the existing users.

# Audit PASS_MAX_DAYS
grep ^PASS_MAX_DAYS  /etc/login.defs
cat /etc/shadow | cut -d : -f 1,5 | grep [0-9]


PASS_MIN_DAYS   7
chage --mindays 7 <user>

# Audit PASS_MIN_DAYS
grep ^PASS_MIN_DAYS  /etc/login.defs
cat /etc/shadow | cut -d : -f 1,4 | grep [0-9]

chage --mindays <days> <user>

PASS_WARN_AGE   7
chage --warndays 7 <user>

# Audit
cat /etc/shadow | cut -d : -f 1,6 | grep [0-9]

# Disable systemd dump storage for backtraces /etc/systemd/coredump.conf.
echo 'storage=none' >> /etc/systemd/coredump.conf

# Audit
grep -i '^storage=[n,e,j]' /etc/systemd/coredump.conf

#  Ensure core dump backtraces /etc/systemd/coredump.conf
echo 'processsizemax=0' >> /etc/systemd/coredump.conf

grep -i '^processsizemax=[0-9][bkmgtpe]*' /etc/systemd/coredump.conf

# Harden the SSH service /etc/ssh/sshd_config
# Directory /etc/ssh/ssh_config.d can be used to enforce the rules instead of editing the main sshd_config
AllowGroups root,wheel
Protocol 2
Port 2169
DenyUsers appadm
HostbasedAuthentication no
PermitRootLogin no # Or PermitRootLogin prohibit-password # Password must be deleted of the root account.
LoginGraceTime 60
PermitUserEnvironment no
PermitEmptyPasswords no
Ciphers aes128-ctr,aes192-ctr,aes256-ctr
MaxAuthTries 4
IgnoreRhosts yes
Banner /etc/issue.net
ClientAliveInterval 600
ClientAliveCountMax 0
UsePAM yes
X11Forwarding no
AllowTcpForwarding yes
StrictModes yes
MaxSessions 10

cp -v sshd_config{,.bak}

# Comment the line.
HostKey /etc/ssh/ssh_host_ed25519_key

# Audit
sshd -T | grep -iE 'AllowGroups|Protocol|DenyUsers|HostbasedAuthentication|PermitRootLogin|LoginGraceTime|PermitUserEnvironment|PermitEmptyPasswords|Ciphers|MaxAuthTries|IgnoreRhosts|Banner|ClientAliveInterval|ClientAliveCountMax|UsePAM|X11Forwarding|AllowTcpForwarding'


# Remove the legacy services
dnf erase telnet-server
rpm -q rsh rcp rlogin telnet-server ftp-server rsh-server tftp-server

# Stop, disable, and mask the unnecessary services.
systemctl disable --now <unit>.service

systemctl mask <unit>.service

# Set password authentication tries.
# Create password policies and history.

cat > /etc/security/pwhistory.conf << EOF
enforce_for_root
use_authtok
remember = 10
retry = 3
EOF

# Audit
grep -vE '^#|^$' /etc/security/pwhistory.conf

# Implement the custom pam configs forcefully.
cat > /etc/security/pwquality.conf.d/pwquality.conf << EOF
enforce_for_root
minlen = 9
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
dictcheck = 1
usercheck = 1
retry = 3
EOF

# Audit
grep -vE '^#|^$' /etc/security/pwquality.conf.d/*.conf /etc/security/pwquality.conf

# Ensure the "su" command is restricted to a specific group only such as sugroup.
# /etc/pam.d/su
groupadd -g 201 sugroup
auth            requisite       pam_wheel.so use_uid group=<group_name>

# To check which user password got changed and when.
journalctl -r -t passwd
journalctl -r -t passwd | grep <user>

# Enable a firewall
systemctl enable --now firewalld

# Ensure that nftables is installed as the only back-end of firewall-cmd
systemctl mask --now iptables.service
systemctl mask --now ip6tables.service

# Ensure that SElinux is not disabled or atleast change SElinux to permissive
# /etc/selinux/config
# Do not enabled SElinux if it is disabled on production.
setenforce 1

# Audit
grep '^SELINUX=[p,e,d]' /etc/selinux/config

# Disable the unnecessary cron jobs.
# Check permissions of the below files.
# /etc/cron.allow
stat -Lc "%a" /etc/cron.deny

# Check the UID and GID of the below file.
stat -Lc "%u:%g" /etc/cron.deny

# Kill and stop the unnecessary ports listening
fuser -n tcp <port> -k

# Keep the system minimal
systemctl set-default multi-user.target

systemctl isolate multi-user.target

# Disable Ctrl+Alt+Delete
systemctl disable --now ctrl-alt-del.target
systemctl mask ctrl-alt-del.target

# Audit
systemctl is-enabled ctrl-alt-del.target
systemctl is-active ctrl-alt-del.target

# Remove unwanted SUID and SGID binaries to avoid privilege escalation attack
# Audit -mount can be used in the place of -xdev
find / -xdev -type f -perm -4000 -print
find / -xdev -type f -perm -2000 -print

# Take a backup of /etc/passwd and /etc/shadow
cp -pv /etc/passwd{,.bak}
cp -pv /etc/shadow{,.bak}

# Verify the default backup file.
ls -l /etc/passwd{,-}
ls -l /etc/shadow{,-}

# Black list the non-required modules.
vim /etc/modprobe.d/np-blacklist.conf
blacklist cramfs
blacklist udf
blacklist squashfs

# Use pam_faillock to protect from brute force.
authselect select sssd with-faillock

cat > /etc/security/faillock.conf << EOF
deny=4
unlock_time=60
even_deny_root
EOF

# Audit.
grep -vE '^#|^$' /etc/security/faillock.conf

# Check which user does not have a password.
cat /etc/shadow | awk -F: '($2 == "" ) { print $1 " does not have a password "}'

# Ensure the permissions and ownership of the crontab files
ls -l /var/spool/cron

# Ensure root is the only 0 UID account.
awk -F: '($3 == 0) { print $1 }' /etc/passwd

# Restrict the sudoers to enter in the root shell.
echo "Defaults noexec" >> /etc/sudoers

# The below command can tamper the sudoers file.
sudo sed -i '$d' /etc/sudoers

# Might to not be able to run cron jobs.
echo "Defaults requiretty" >> /etc/sudoers

# Change the default PATH when the sudo command is run.
Defaults secure_path = /sbin:/usr/bin

# Not allow to run executables in the current directory.
echo "Defaults ignore_dot" >> /etc/sudoers

# Change the password timeout to 2 minutes, default is 15.
echo "Defaults passwd_timeout=2" >> /etc/sudoers


# Monitor the bash history.
vim /etc/profile.d/history.sh

readonly HISTSIZE=1000
readonly HISTFILESIZE=2000
readonly HISTTIMEFORMAT="%Y-%m-%d %T "
readonly PROMPT_COMMAND='history -a'
user=$(who am i | awk '{print $1}')
name=$(whoami)
readonly HISTFILE="/var/log/bash_history/${user}_as_$(whoami)_history"
export HISTFILE HISTSIZE HISTFILESIZE PROMPT_COMMAND

sudo mkdir /var/log/bash_history

sudo chmod 1777 /var/log/bash_history

sudo chattr +a /var/log/bash_history

# To interpret the time stamps in the history file.
date -d @1714836210

# Disable the root account.
# But still can SSH in the root account if the default root shell is not changed to nologin.
sudo chsh -s /sbin/nologin root

# Add the below settings in the /etc/sudoers file.
Defaults noexec
Defaults ignore_dot

# Deny wheel group members or any other sudo user to escape into the root shell as root.
%sudogrp ALL=(ALL) PASSWD: ALL, !/bin/bash, !/bin/sh, !/usr/bin/* *sudoers, !/home/*/*, !/usr/sbin/visudo, !/bin/* /bin/*, !/bin/* /sbin/*, !/usr/bin/* *shadow, !/usr/bin/* *group, !/usr/bin/* *passwd

# Also the below commands should be restricted.
# /usr/bin/pkexec, /sbin/shutdown, /sbin/reboot, /usr/sbin/usermod, /usr/sbin/userdel, /usr/sbin/useradd, /usr/bin/passwd

# Lock the root account.
sudo usermod -L root

# Lock the password of the root account.
sudo passwd -l root

# But still can SSH in the root account if the default root shell is not changed to nologin.

# Exclude a list of packages that can cause vulnerabilities.
vim /etc/yum.conf
exclude=nano,telnet-server,rsh,rlogin

# Add noexec in mount options to limit the paths where executabes can be executed.

# Beaware of bash --norc

# Even with "Defaults noexec" is used in /etc/sudoers one can escape to the root shell can drop a fork bomb.

# Instead of blacklisting the system commands not to be run by sudo, whitelist only certain commands.

# Hide the processes of the root user from the other users.
mount -o remount,rw,noexec,hidepid=2 /proc

# Setting system wide crypto policies.
update-crypto-policies --show

# Secure modes avaalable: FIPS, FUTURE
update-crypto-policies --set FUTURE
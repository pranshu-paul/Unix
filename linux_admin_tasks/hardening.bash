# Hardening and system auditing

# Ensure the below paths exist on a separate partition or LVM.
# With noexec, nosuid, and nodev.
# noexec not on /home and /var
/dev/shm           
/home              
/var               
/var/tmp           
/var/log           
/var/log/audit     
/tmp      
/opt
/usr
/srv

# Audit
grep TMOUT /etc/profile /etc/bashrc /etc/profile.d/*

# Set the session timeout.
echo 'readonly TMOUT=600; export TMOUT' > /etc/profile.d/tmout.sh

# Set a local terminal warning before the users login.
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

# Tuning kernel parameters.
# Applying a parameter individually
# sysctl -w <paramater>=<value>
# Precedence of the parameters matters.

exec &>> /etc/sysctl.d/10-custom.conf

# Controls the System Request debugging functionality of the kernel
echo "kernel.sysrq = 0"

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
echo "kernel.core_uses_pid = 1"

# Disable IPv6.
# default: disable the new interfaces.
# all: disable all the interfaces.
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

# Disable IP forwarding.
net.ipv4.ip_forward = 0

# Disable packet forwards.
net.ipv4.conf.all.send_redirects = 0

# Disable multicast forwarding.
net.ipv4.conf.all.mc_forwarding = 0

# Enable ignoring broadcasts request.
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Avoid SYN floods at the kernel level.
# Avoid Denial-of-Service if the system not getting ACKs.
net.ipv4.tcp_syncookies = 1

# Enables reverse path filtering
# Drops packets with source addresses that should not have been able to be received on the interface they were received on.
# Set 1 for strict and 2 for loose filtering.
# The kernel verifies that the source address of the packet is reachable via the same interface.
# Prevents IP spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Do not accept source routing.
echo "net.ipv4.conf.all.accept_source_route = 0"

# Restricts the use of ptrace, a debugging tool 
echo "kernel.yama.ptrace_scope = 1"

# Enable full address space randomization
echo "kernel.randomize_va_space = 2"

echo "net.ipv4.conf.all.secure_redirects = 0"

# Reboots the node in case of voltage fluctuations, peripheral failures, buggy firmware.
# To verify the interrupts cat /proc/interrupts | grep NMI
echo "kernel.unknown_nmi_panic = 1"

# Enabled logging of invalid source addresses
# Logs suspicious packets
echo "net.ipv4.conf.all.log_martians = 1"
echo "net.ipv4.conf.default.log_martians = 1"

# Prevent new modules from loading
echo "kernel.modules_disabled = 1"

# ===== Audit ===== #
for file in /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf
do
	grep send_redirects ${file}
done

sysctl -a --pattern net.ipv4.conf.all.send_redirects

grep -o 'ipv6.disable=[0,1]' /boot/efi/EFI/centos/grubenv

for file in /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf
do
	grep disable_ipv6 "$file"
done

sysctl -a --pattern disable_ipv6

for file in /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf
do
	grep tcp_syncookies "$file"
done

sysctl -a --pattern net.ipv4.tcp_syncookies

# ===== Audit ===== #

# Refresh the connection.
# Any temporary settings will be removed such as routes.
nmcli con up ens33

# Define password policies in the login.defs file.

PASS_MAX_DAYS   35
chage --maxdays <days> <user> # For the existing users.

# Audit PASS_MAX_DAYS
grep ^PASS_MAX_DAYS  /etc/login.defs
cat /etc/shadow | cut -d : -f 1,5 | grep [0-9]


PASS_MAX_DAYS   90
chage --maxdays 90 <user>

# Audit PASS_MIN_DAYS
grep ^PASS_MIN_DAYS  /etc/login.defs
cat /etc/shadow | cut -d : -f 1,4 | grep [0-9]

chage --mindays <days> <user>

PASS_WARN_AGE   7
chage --warndays 7 <user>

# Audit
cat /etc/shadow | cut -d : -f 1,6 | grep [0-9]

# Disable systemd dump storage for backtraces /etc/systemd/coredump.conf.
echo 'Storage=none' >> /etc/systemd/coredump.conf

# Audit
grep -i '^storage=[n,e,j]' /etc/systemd/coredump.conf

#  Ensure core dump backtraces /etc/systemd/coredump.conf
echo 'ProcessSizeMax=0' >> /etc/systemd/coredump.conf

grep -i '^processizemax=[0-9][bkmgtpe]*' /etc/systemd/coredump.conf

# Harden the SSH service /etc/ssh/sshd_config
# Directory /etc/ssh/sshd_config.d can be used to enforce the rules instead of editing the main sshd_config
AllowGroups root,wheel
Port 2169
DenyUsers appadm
HostbasedAuthentication no
PermitRootLogin no # Or PermitRootLogin prohibit-password # Password must be deleted of the root account.
LoginGraceTime 60
PermitUserEnvironment no
PermitEmptyPasswords no
MaxAuthTries 4
IgnoreRhosts yes
Banner /etc/issue.net
ClientAliveInterval 600
ClientAliveCountMax 0
UsePAM yes
X11Forwarding no
SyslogFacility AUTHPRIV
AllowTcpForwarding yes
ChallengeResponseAuthentication no
StrictModes yes
MaxSessions 10
MaxStartups 10:30:60
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

cp -v sshd_config{,.bak}

# Comment the line in the crypto policies FIPS mode.
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
# maxrepeat = 3
# maxsequence = 3
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

# Apply the changes.
authselect select sssd with-pwhistory without-nullok

# Ensure that the pam_unix is secureand uses sha512 does not remeber=0 authtok.

# Audit
grep -r -vE '^#|^$' /etc/security/pwquality.conf.d /etc/security/pwquality.conf

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

# To avoid Ctrl-Alt-Del pressed more than 7 times in 2 seconds
/etc/systemd/system.conf
CtrlAltDelBurstAction=none

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

cat > /etc/security/faillock.conf << EOF
deny=4
unlock_time=600
even_deny_root
EOF

# Use pam_faillock to protect from brute force.
authselect select sssd with-faillock with-pwhistory without-nullok
faillock --user <user>
faillock --user <user> --reset
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

# The sed command can tamper the sudoers file.
sudo sed -i '$d' /etc/sudoers

# Might to not be able to run cron jobs.
echo "Defaults requiretty" >> /etc/sudoers

# Change the default PATH when the sudo command is run.
Defaults secure_path = /usr/sbin:/usr/bin

# Not allow to run executables in the current directory.
echo "Defaults ignore_dot" >> /etc/sudoers

# Change the password timeout to 2 minutes, default is 15.
echo "Defaults passwd_timeout=2" >> /etc/sudoers


# Monitor the bash history.
vim /etc/profile.d/history.sh

readonly HISTSIZE=2000
readonly HISTFILESIZE=3000
readonly HISTTIMEFORMAT="%Y-%m-%d %T "
readonly PROMPT_COMMAND='history -a'
readonly HISTFILE="/var/log/bash_history/$(logname)_as_$(whoami)_history"
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

# Secure the SSH CBC
update-crypto-policies --set DEFAULT:NO-SHA1:NO-SSHCBC:NO-WEAKMAC

# Due to exceptions made, firewall is disabled.
# We are enabling setting the firewall's default target to ACCEPT all the traffic.
firewall-cmd --permanent --set-target=ACCEPT

# Add the below firewall-cmd rich rule to drop server's time set through ICMP replies.
# Drop the ICMP timestamp requests type (13), and the outgoing ICMP timestamp replies type (14).
firewall-cmd --permanent --add-rich-rule='rule icmp-type name="timestamp-request" drop'
firewall-cmd --permanent --add-rich-rule='rule icmp-type name="timestamp-reply" drop'

# Reload the firewall after all the configuration changes made.
firewall-cmd --reload

# Verify the changes made.
nping --icmp --icmp-type 13 192.168.227.128
nping --icmp --icmp-type 14 192.168.227.128


# Disable Avahi daemon.
systemctl disable --now avahi-daemon

# Mask the service
systemctl mask avahi-daemon


# Verify the whether the mDNS avahi daemon is disabled.
# Reply filtered means the service is not running on the server.
nmap --script=dns-service-discovery -p 5353 192.168.227.128

# Verify whether the cbc ciphers are disabled.
ssh -o Ciphers=aes128-cbc localhost
ssh -oCiphers=aes128-cbc,aes256-cbc 127.0.0.1

# Create a directory if doesn't exist.
mkdir /etc/crypto-policies/policies/modules

vi /etc/crypto-policies/policies/modules/DISABLE-CBC.pmod
# Disable CBC ciphers
cipher@SSH = -AES-128-CBC -AES-256-CBC

# Disable ChaCha20-Poly1305 cipher
cipher@SSH = -CHACHA20-POLY1305

# Disable Encrypt-then-MAC (ETM) algorithms
ssh_etm = 0

# Disable SSH Weak Key Exchange Algorithms Enabled
# Remove diffie-hellman-group-exchange-sha1 from both the files.
vi /etc/crypto-policies/back-ends/openssh.config
vi /etc/crypto-policies/back-ends/opensshserver.config

# Verify the changes,
grep -i diffie-hellman-group-exchange-sha1 /etc/crypto-policies/back-ends/openssh.config
grep -i diffie-hellman-group-exchange-sha1 /etc/crypto-policies/back-ends/opensshserver.config

# Try to connect. It should NOT work.
ssh -o KexAlgorithms=diffie-hellman-group-exchange-sha1 127.0.0.1

# Restart the sshd daemon. Reloading it won't work.
systemctl restart sshd

# Disable SSH Terrapin Prefix Truncation Weakness
# Disable ChaCha20-Poly1305 cipher
vi /etc/crypto-policies/policies/modules/DISABLE-CBC.pmod
cipher@SSH = -CHACHA20-POLY1305

# Verify CVE-2023-48795
ssh -o Ciphers=chacha20-poly1305@openssh.com localhost

# Apply the changes made to the crypto policies.
update-crypto-policies --set DEFAULT:DISABLE-CBC

# Enable the fips mode.
# FIPS mode is not recommened.
fips-mode-setup --enable

# Check the fips mode
fips-mode-setup --check

# Secure modes available: DEFAULT, FIPS, FUTURE
update-crypto-policies --set DEFAULT

# To prevent a fork bomb
ulimit -u 30

# To set a user level hard limit.
/etc/security/limits.d/pranshu.conf
pranshu hard nproc 30

# Set password on GRUB.
# Default user name will be root.
grub2-setpassword

# Run the vulnerability test.

# Install the OpenSCAP scanner.
dnf -y install httpd openscap-scanner scap-security-guide

wget -O - https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-8.oval.xml.bz2 | bzip2 --decompress > rhel-8.oval.xml

oscap oval eval --report vulnerability.html rhel-8.oval.xml

# Scanning a remote system for vulnerabilities.
oscap-ssh joesec@machine1 22 oval eval --report remote-vulnerability.html rhel-8.oval.xml

# Fetching configurational failed vulnerabilities.
# Another profiles: xccdf_org.ssgproject.content_profile_stig
oscap xccdf eval --fetch-remote-resources --profile xccdf_org.ssgproject.content_profile_pci-dss --results /tmp/scan-xccdf-results.xml /usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml

# Generate an HTML report.
oscap xccdf generate report /tmp/scan-xccdf-results.xml > /var/www/html/index.html
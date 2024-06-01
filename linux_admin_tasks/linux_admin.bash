# Adminstration Commands Summary #

# =================================================================================== Specfic of el7 and el8 ============================================================ #

ls -ltrSh		# -- Sorts by the size of the files in ascending order.
du -csh *		# -- Shows the total of all the files and folders in the current directory.
du -h		# -- Shows the list of size of all the files and folders.
ls -ld */		# Lists the directories in the current directory.

ls -l ?????.txt		# -- To search for a file with a five-character name.

# The below command takes backups.
# Values available for the variable "VERSION_CONTROL".
# This variable also works with cp, mv as well.
# none, off       never make backups (even if --backup is given)
# numbered, t     make numbered backups
# existing, nil   numbered if numbered backups exist, simple otherwise
# simple, never   always make simple backups
export VERSION_CONTROL=numbered
install -b -v -D -m 644 <file> <destination>

install -v -owner postgres <file_1> <file_2> <destination>

# Taking backups with the "VERSION_CONTROL" variable exported.
# Standard options with cp: -r --recursive, -p (preserve) 
cp -v --backup <file/directory> <destination>

stat / | grep 'Birth:' | awk '{print $2}'		# Shows the operating system's installation date.
file <file_name>		# -- Shows the file type for a file.
file httpd.crt		# -- An example.
tr -dc "A-Za-z0-9" < /dev/urandom | fold -w 100 | head -n 1000000 > bigfile.txt		# Creates a random file for the testing purpose around 97MB.

sed 's/string/replacement/g' <file>		# Find and replace

diff <file_1> <file_2>		# -- Shows the difference between two files.

# To create a hardlink.
ln <file> <hardlink>

# To create a softlink on a different file system.
ln -rs <file> <softlink>

# To create a soft link.
ln <file> <softlink>
cp -pvr <directory_name> $OLDPWD		# -- Copies the directory to the previous working directory.

export -p | grep -v 'declare -x LS_COLORS'		# -- To print all the set environment variables.
unset -v <variable_name>		# -- To unset a variable.
unset -f <function_name>		# -- To unset a function.

alias <alias>="<command_with_options>" ; alias sbs="ls -ltrhS"
unalias <alias>

nohup <command> &		# -- Avoids the command hanging up and sends it to the background.

cat /etc/os-release

source <file>		# Source an environment file. Variables, Functions, Aliases, Arrays.

grep -nE 'ORA-|RMAN-' rman.log		# -- Searches for the errors in the RMAN restore or backup log.
grep -n 'ERRORCODE = [1,2]' <any_log>		# -- Searches for the errors in EBS related logs.
wc -l RMAN.log		# Prints the total number of lines in a file.
grep -n 'ORA-' ERPPROD_db_11082022_003001.out		# Shows on which line number the error is.
grep 'ORA-' alert_$ORACLE_SID.log		# -- Searches for the errors in the alert log.
grep -vE '^#|^$' <file>		# To remove comments and empty lines from a file.

crontab -e		# To scheduled a job for the user.
crontab -u root -l		# To list the scheduled jobs of the user.
crontab <cron_file>		# To install a new crontab entry.
# */15 * * * * /path/to/<command\scipt>		# Every fifteen minutes.
# * */1 * * * /path/to/<command\scipt>		# Every hour.
# @reboot /path/to/<command\scipt>		# Every reboot.

df -h --total		# -- Shows the system's total storage capacity.
df -hT $PWD		# -- Shows the file system of the mounted drives and the current directory.
df --output -h		# -- Shows a verbose output of the mount points.

echo "---"  > /sys/class/scsi_host/host0/scan

df -h --total | sed -n '1p;$p'		# Prints only the first and last line.

sudo edquota --user username		 # Sets

find . -name <name> -type <T> -print		# -- Type could be "d" directory, "f" file, "l" sym link, and "b" block device.
find . -user oracle -exec rm -fvr {} \;
find . -user orap -mtime 10 -exec rm -v {} \;
find . -type f -exec file {} \;

find /u01 -size +5M -print		# To find files by their size; M -- for megabyte, G -- for gigabyte, K -- for kilobyte

tar -cvzf <compress_name>.tar.gz ./<file_name>
tar -tvf | head -1 
tar -xvzf <compress_name>.tar.gz <path>
unzip <path_to_the_zip>.zip -d <output_directory>		# To output the zip to a specific directory.
unzip -l <path_to_the_zip>.zip		# To list the zip file contents.

which <command>		# For any command. If the command is in /usr/sbin, then that command requires the root privileges.
which <alias> 
which <function>
type -a <command/bash_builtin>

# ======================================================================================== NETWORKING ====================================================================== #
hostname -f		# -- Shows the fully qualified domain name of the hostname.
ip -4 addr show <nic_name> 
ip -4 -brief address show ens3 # To get the ipv6 just remove the "-4" flag.
ip route show		# -- To get the default system network route.
hostname -I		# -- Shows the system's IP addresses.
hostname -i 	# -- Shows which IP address is linked with the hostname.
hostname -d 	# -- Shows the domain name of the system.

nmcli con mod ens34 +ipv4.address 192.168.1.100/24 +ipv4.gateway 192.168.1.1 + ipv4.dns 192.168.1.1		# To assing a static IP address
nmcli con up ens34		# Apply the changes without restarting the interface.

dmesg | grep eth		# -- Lists the connected NICs.

nmcli con show
nmcli dev show <device_name>		# Prints the device gateway, DNS, and routes

ip neigh show		# -- To see nieghbour IPs; uses ARP.
ss -lntp		# -- Shows port, pids, process name, LISTENING.
ss -snt		# Prints the stats of network connections and established TCP connections.

ss -lntu		# Lists listening TCP and UDP sockets in numeric format.

firewall-cmd --add-port<port>/<protocol>		# Add a port
firewall-cmd --add-port<port>/<protocol> --permanent		# Make the rule permanent, without losing any temporary rules.

nc -zv <sub_domain>.<domain>.<tld> <port>
nc -zvu 4.2.2.2 53
nc -zv miditech0092.miditech.co.in 8040
curl -v telnet://www.oswebadmin.com:443
curl ifconfig.co	# -- Loads the server's public IP.
curl -L <the_url> --output <any_file_name>		# -- To download a file. -L is for redirection

curl cheat.sh/<any_linux_or_unix_command>		# -- To get the structure of commands for the syntax.

fuser -n tcp <port> -k		# To kill a TCP port.

# DNS lookups.
host <domain_name>		# Package = bind-utils
host -t ptr 4.2.2.2		# -- Reverse DNS lookup.
host <domain_name> <dns_server>
host -t txt google.com

ssh <user_name>@<ip_address> [-p <port>]
# For the ports up to 1024 requires root priviledges. So, use a port above 1024 in place of <any_random_port>.
ssh <user_name>@<remote_ip_address> -L <any_random_port>:<remote_loopback_address>:<target_port>		# -- Local port forwarding.
ssh-copy-id <user_name>@<ip_address>		# To setup password less authentication.
ssh-copy-id -i <private_key> -p <port> <user_name>@<ip_address>		# To setup the password less authentication.

# -- MAILING IN LINUX -- # 
echo <message> | mail -s "<subject>" -a <file_path> example@domain.com		# Recipient address.
echo <message> | mail -s "<subject>" -c <carbon_copy, carbon_copy...> -b <BLIND_CARBON_COPY, BLIND_CARBON_COPY...> example@domain.com		# Recipient address.
echo -e "<message>" "\n<message>" | mail -s "<subject>" -a <file_path> example@domain.com		# -- Sending multiline e-mail.
mailq		# -- To check the mail queue.
postsuper -d <message_id>		# To delete a specific mail from the mail queue.

postsuper -d ALL		# To clear the mailq.

# ================================================================================ SYSTEM AND PROCESS MANAGEMENT ===================================================================== #
dmidecode		# Prints.. what the BIOS detected.

grep -c ^processor /proc/cpuinfo		# Lists number of cores available.

cat /etc/system-release		# Prints the OS version and release.

w		# -- Shows how many users are logged in. Can also use to check at which display port VNC is running.

whoami		# -- Shows the current user logged in.
last reboot | head -1		# -- Shows last reboot time.
free -h		# -- Shows the information about the memory. /proc/meminfo

hostnamectl set-hostname <hostname>.<domain>.<tld>		# Sets the new hostname

uptime		# -- Shows the system's uptime with load average.
uptime -p		# -- Shows the brief output of the uptime command.

ps -eo pid,ppid,cmd,pmem,pcpu,user,time,euser,stat,flags,wchan --sort=-pcpu | grep -v grep | head		# -- Top 15 processes eating cpu.
ps -f <pid> <ppid> ...
 ps -eo pid,ppid,pmem,pcpu,user,time,euser,ruser,comm --sort=-pcpu
ps -eo pid,ppid,cmd,pmem,pcpu,user,time,euser,stat,flags,ruser,wchan | grep pranshu
ps -eo pid,ppid,pmem,pcpu,user,time,euser,ruser,comm

renice -n <nice_value> -p <pid>		# To change a process priority.

ps -u <user_name>
pstree <ppid>
pkill <process_command>
top -u oracle # Shows all the process of the oracle user.
top -c # Shows the order by the high cpu usage.
ps aux | head -n1; ps aux | grep -w ^postgres # Shows a user specific processes.

# To pause a process.
kill -SIGSTOP <pid>

# To continue a process.
kill -SIGCONT <pid>

watch -d -n 3 'ps -f 2180 9714'		# -- For process monitoring.

# In systemd based systems every thing is a unit file: daemon, nic, filesystem, user. Files like: /etc/hosts, /etc/fstab, /etc/resolv.conf
systemctl enable --now <service_name>.service		# For the new services, it starts and enables in a single command.
systemctl disable --now <service_name>.service		# For the services

systemctl isolate multi-user.target # Change the target. systemctl get-default # Get the default target; systemctl set-default # Sets the default target.

journalcrl -r -S today		# Shows today logs.

# Standard options are: start, stop, restart, and status. 
systemctl <option> <service_name>.service

# Create a user.
useradd -r -m -d /home/pranshu -s /bin/bash -c 'Support User' -u 201 -g system -G adm -e 2025-01-01 pranshu

# -- Getting help in Linux. -- #
man -k <any_command_keyword>
whatis <command>

# For the bash commands and bash builtins.
help # To get help for the bash builtins.
help <bash_bultin>
help -m <bash_bultin> # To get some short help.

chage -l <user> # Change the user's password expiry information.

cat /etc/passwd | grep -E /bin/'b?a?sh'

echo 'vm.overcommit_memory = 2' /etc/sysctl.d/10-custom.conf		# To modify kernel parameters.

sysctl -w vm.overcommit_memory=2

# =============================================================================== OPENSSL AND MANAGING CERTIFICATES ================================================================ #
# To see the details about the certificate request.
openssl req -text -noout -verify -in <csr>.csr

# To show the certificate's information of the generated certificate.
openssl x509 -noout -issuer -subject -dates -fingerprint -email -trustout -in <CERTIFICATE_NAME>.crt

# To generate a wildcard self signed certificate. The cert can be used a root cert.
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout <certificate>.key -out <certificate>.crt -subj "/CN=*.example.com"

# Standard arguments with commands in linux.
# -v --verbose: Can be used with cp, mv, rm, and most of the commands.
# -h --human-readable: Can be used with df, ls, free, du, ps 

# Always use the directory with ".d" extension to add any custom configuration.
# Or use the "include" directive in the main file pointing to the custom configuration.
# For eg. include <path_with_file_name>.conf OR include <path>*.conf

# =================================================================================== Managing Packages ================================================================================ #
# Use "yum" instead of "dnf" in RHEL 7.
# Standard options: search, install, erase, download, list
# Try to use wild cards or regex with the "list" option.
dnf -y <option> <package_name>
dnf -y install <url>.rpm

# Check which package installed the package.
rpm -qf <path\to_file\to_directory.>

dnf provides <command_name> # Searches which package is required for the command or library.

# Important variables. $PATH, $LD_LIBRARY_PATH
(echo $SSH_CLIENT; echo $VERSION_CONTROL; echo $BASHPID)		# Run commands in a sub shell.
printenv SSH_CLINET

# To run multiple commands as a single unit.
{ echo $VERSION_CONTROL; echo $SSH_CLIENT; }

sos report		# Takes a system config snapshot for troubleshooting.
# Last edited: 8/14/2023

# ONLY FOR ORACLE DATABASE WITH EBS TECHNOLOGY STACK.
# Standard user COMMANDS; Not requires any root privilege or wheel group membership.
# EXCLUSIVE FOR RHEL 7 AND RHEL 8.
# NOT USABLE ON SOLARIS AND AIX.

ls -ltrSh # -- Sorts by the size of the files in ascending order.
du -csh * # -- Shows the total of all the files and folders in the current directory.
du -h # -- Shows the list of size of all the files and folders.
ls -ld */ # Lists the directories in the current directory.

ls -l ?????.txt # -- To search for a file with a five-character name.

# The below command takes backups.
# Values available for the variable "VERSION_CONTROL".
# This variable also works with cp, mv as well.
# none, off       never make backups (even if --backup is given)
# numbered, t     make numbered backups
# existing, nil   numbered if numbered backups exist, simple otherwise
# simple, never   always make simple backups
export VERSION_CONTROL=numbered
install -b -v -D <file> <destination>


# Taking backups with the "VERSION_CONTROL" variable exported.
# Standard options with cp: -r --recursive, -p (preserve) 
cp -v --backup <file/directory> <destination>

stat / | grep 'Birth:' | awk '{print $2}' # Shows the operating system's installation date.
file <file_name> # -- Shows the file type for a file.
file httpd.crt # -- An example.
tr -dc "A-Za-z0-9" < /dev/urandom | fold -w100|head -n 100000 > bigfile.txt # Creates a random file for the testing purpose.

diff <file_1> <file_2> # -- Shows the difference between two files.

cp -pvr <directory_name> $OLDPWD # -- Copies the directory to the previous working directory.

export -p | grep -v 'declare -x LS_COLORS' # -- To print all the set environment variables.
unset -v <variable_name> # -- To unset a variable.
unset -f <function_name> # -- To unset a function.

alias <alias>="<command_with_options>" ; alias sbs="ls -ltrhS"
unalias <alias>

nohup <command> & # -- Avoids the command hanging up and sends it to the background.

source EBSapps.env run # To source the EBS environment file for the run-file-system.

kill -9 $(ps -ef | grep LOCAL=NO | grep $USER | grep $ORACLE_SID | grep -v grep | awk '{print $2}') # -- For DB
kill -9 $(ps -ef | grep FND | grep $TWO_TASK | grep $USER | grep -v grep | awk '{print $2}') # -- For APPL


grep -n -e 'ORA-' -e 'RMAN-' rman.log # -- Searches for the errors in the RMAN restore or backup log.
grep -n 'ERRORCODE = [1,2]' <any_ebs_log> # -- Searches for the errors in EBS related logs.
cat RMAN.log | wc -l
grep -n 'ORA-' ERPPROD_db_11082022_003001.out # Shows on which line number the error is.
grep 'ORA-' alert_$ORACLE_SID.log # -- Searches for the errors in the alert log.
grep -v -e \# -e '^$' db.rsp

crontab -e # To scheduled a job for the user.
crontab -l # To list the scheduled jobs of the user.


# -- CDB ENV FILE MUST BE SOURCED BEFORE USING THE BELOW COMMAND.; FOR THOSE ENVIRONMENT WHOSE SID IS IN UPPERCASE.
cd $ORACLE_HOME/admin/$CONTEXT_NAME/diag/rdbms/$(echo $ORACLE_SID|tr [:upper:] [:lower:])/$ORACLE_SID/trace/
less $ORACLE_HOME/admin/$CONTEXT_NAME/diag/rdbms/$(echo $ORACLE_SID|tr [:upper:] [:lower:])/$ORACLE_SID/trace/alert_$ORACLE_SID.log

df -h # -- Shows the mount points.
df -h --total # -- Shows the system's total storage capacity.
df -h $PWD # -- Shows the free disk avilable in the current directory.
df -hT # -- Shows the file system of the mounted drives.
df --output -h # -- Shows a verbose output of the mount points.

df -h --total | head -1 ; echo "$(df -h --total | tail -1)"
df -h --total | awk 'NR == 1; END{print}'


find . -name <name> -type <T> -print # -- Type could be "d" directory, "f" file, "l" sym link, and "b" block device.
find . -user oracle -exec rm -fvr {} \;
find . -user orap -mtime 10 -exec rm -v {} \;
find . -type f -exec file {} \;

find /u01 -size +5M -print # To find files by their size; M -- for megabyte, G -- for gigabyte, K -- for kilobyte

tar -cvzf <compress_name>.tar.gz ./<file_name>
tar -tvf | head -1 
tar -xvzf <compress_name>.tar.gz <path>
unzip <path_to_the_zip>.zip -d <output_directory> # To output the zip to a specific directory.
unzip -l <path_to_the_zip>.zip # To list the zip file contents.

which <command> # For any command. If the command is in /usr/sbin, then that command requires the root privileges.
which <alias> 
which <function>
type -a <command/bash_bultin>



# -- NETWORKING -- #
hostname -f # -- Shows the fully qualified domain name of the hostname.
ip -4 addr show <nic_name> 
ip -4 addr show ens3
ip route show # -- To get the default system network route.
hostname -I # -- Shows the system's IP addresses.
hostname -i # -- Shows which IP address is linked with the hostname.
hostname -d # -- Shows the domain name of the system.

dmesg | grep eth # -- Lists the connected NICs.

nmcli con show
nmcli dev show <device_name>

ip neigh # -- To see nieghbour IPs; uses ARP.
ss -lntp # -- Shows port, pids, process name, LISTENING.
netstat -lntp # -- For the old distros. # Package = net-tools
ss -lntp | grep smon
ss -lntp | grep <port>

nc -zv <sub_domain>.<domain>.<tld> <port>
nc -zv google.com 443
nc -zv miditech0092.miditech.co.in 8040
curl -v telnet://<ip_address>:1521
curl ifconfig.co # -- Loads the server's public IP.
curl -oL <any_file_name> <the_url> # -- To download a file.
curl -I <url>
curl --proxy socks5://127.0.0.1:1080 http://example.com


curl cheat.sh/<any_linux_or_unix_command> # -- To get the structure of commands for the syntax.

# DNS lookups.
dig <domain_name> # Package = bind-utils
dig -x 8.8.8.8 # -- Reverse DNS lookup.
dig @<dns_server> <domain_name>

host <domain_name>
host -t TXT <domain_name>

lsnrctl start <listener_name>
lsnrctl status <listener_name>
lsnrctl reload <listener_name>


ssh <user_name>@<ip_address> [-p <port>]
# For the ports up to 1024 requires root priviledges.
# So, use a port above 1024 in place of <any_random_port>.
ssh <user_name>@<remote_ip_address> -L <any_random_port>:<remote_loopback_address>:<target_port> # -- Local port forwarding.
ssh-copy-id <user_name>@<ip_address> # To setup password less authentication.
ssh-copy-id -i <private_key> -p <port> <user_name>@<ip_address> # To setup the password less authentication.



# -- MAIL IN LINUX -- # 
echo <message> | mail -s "<subject>" -a <file_path> example@domain.com # Recipient address.
echo <message> | mail -s "<subject>" -c <carbon_copy, carbon_copy...> -b <BLIND_CARBON_COPY, BLIND_CARBON_COPY...> example@domain.com # Recipient address.
echo -e "<message>" "\n<message>" | mail -s "<subject>" -a <file_path> example@domain.com # -- Sending multiline e-mail.
mailq # -- To check the mail queue.



# -- SYSTEM AND PROCESS MANAGEMENT -- #
cat /etc/system-release

w # -- Shows how many users are logged in.
w # -- Can also use to check at which display port VNC is running.

whoami # -- Shows the current user logged in.
last reboot | head -1 # -- Shows last reboot time.
free -h # -- Shows the information about the memory.

uptime # -- Shows the system's uptime.
uptime -p # -- Shows the brief output of the uptime command.

lsof -u oracle # -- Shows all the open files from the oracle user.
lsof -u $USER | grep $ORACLE_HOME | wc -l # -- For DB
lsof -u $USER | grep $RUN_BASE | wc -l # -- For APPL
ps -eo pid,ppid,cmd,pmem,pcpu,user,time --sort=-pcpu | grep -v root | head -15 # -- Top 15 processes eating cpu.
ps -f <pid> <pid> ...
ps -f <ppid> <ppid> ...
ps -u <user_name>
pstree <ppid>
pkill <process_command>
top -u oracle # Shows all the process of the oracle user.
top -c # Shows the order by the high cpu usage.

watch -n 3 'ps -f 2180 9714'  # -- For process monitoring.

systemctl enable --now <service_name>.service # For the new services, it starts and enables in a single command.
systemctl disable --now <service_name>.service # For the services

# Standard options are: start, stop, restart, and status. 
systemctl <option> <service_name>.service



# -- Getting help in Linux. -- #
man -k <any_command_keyword>
whatis <command>

# For the bash commands and bash builtins.
help # To get help for the bash builtins.
help <bash_bultin>
help -s <bash_bultin> # To get some short help.



# -- OPENSSL AND MANAGING CERTIFICATES -- #
# To see the details about the certificate request.
openssl req -text -noout -verify -in <csr>.csr

# To show the certificate's information of the generated certificate.
openssl x509 -noout -issuer -subject -dates -fingerprint -email -trustout -in <CERTIFICATE_NAME>.crt

# To generate a self signed certificate.
openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
-keyout tomcat.key \
-out tomcat.crt \
-subj "/C=IN/ST=Delhi/L=Delhi/O=OSWebAdmin/OU=Linux administration/CN=*.oswebadmin.com" &> /dev/null

# To verify a chain of trust
openssl verify -CAfile TrustedRoot.crt -verbose DigiCertCA.crt



# -- APPENDIX -- #

# Standard arguments with commands in linux.
# -v --verbose: Can be used with cp, mv, rm, and most of the commands.
# -h --human-readable: Can be used with df, ls, free, du, ps 

# Always use the directory with ".d" extension to add any custom configuration.
# Or use the "include" directive in the main file pointing to the custom configuration.
# For eg. include <path_with_file_name>.conf OR include <path>*.conf

# Managing Packages
# Requires root access or sudo privileges.
# Use "yum" instead of "dnf" in RHEL 7.
# Standard options: search, install, erase, download, list
# Try to use wild cards or regex with the "list" option.
dnf -y <option> <package_name>
dnf -y install <url>.rpm

dnf provides <command_name> # Searches which package is required for the command.


# -- CDB name can also be provided in the place of PDB name.
sqlplus sys/<password>@<ip_address>:<port>/<pdb_name> as sysdba
sqlplus sys/manager@192.168.1.12:1532/TEST as sysdba

# Important variables.
echo $ORACLE_SID
echo $TWO_TASK
echo $TNS_ADMIN

echo $SSH_CLIENT
echo $VERSION_CONTROL

sqlplus / as sysdba
SQL> host <any_unix_command>
SQL> ! <any_unix_command>

sh adstrtal.sh apps/apps <<< weblogic123 # Automate apps startup.
sh adstpall.sh apps/apps <<< weblogic123 # Automate apps stop.

stat -c "%B %b" apex_22.1_en.zip
SIZE_OF_EACH_BLOCK NUMBER_OF_BLOCKS_TAKEN

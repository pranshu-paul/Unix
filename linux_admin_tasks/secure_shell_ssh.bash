# Commands -- ssh, sshd, sftp, scp, ssh-copy-id, ssh-keygen, w ,semanage
# Packages openssh, openssh-server
# Configuration files.
# /etc/ssh/sshd_config, /etc/ssh/sshrc, ~/.ssh/rc, ~/.hushlogin, /etc/motd, ~/.authorized_keys

# TO CREATE AUTHORIZED_KEYS FILE.
cd ~ ; mkdir .ssh ; chmod 700 .ssh ; cd .ssh ; touch authorized_keys ; chmod 600 authorized_keys ; cd ~

# TO CHECK LOGS OF SSHD.
journalctl -f -t sshd

# TO CHECK WHICH IP ARE CONNECTED TO SERVER.
ss -nHtup | awk '{print $6}' | cut -d : -f 1 | sort | uniq -c | sort -nr | nl
ss -nptu | awk '{print $5 "   :   "  $6}'

# TO CHECK WHICH IPs ARE HITTING SERVER.
awk '{print $12}' /var/log/audit/audit.log | grep addr= | sort | uniq -c | sort -nr | sed "1 d" | nl

# TROUBLESHOOTING.
#When changing the port, first enable the port on the firewall then SElinux.
semanage port -a -t ssh_port_t -p tcp <port>
firewall-cmd --zone=public --add-service=ssh --permanent

# After changing port in sshd_config.
# When changing configuration in sshd_config.
# Use "sshd -t" to check whether the configuration is ok or not.
# Restart sshd.service "systemctl restart sshd.service"
# Use "w" command to check who is logged into the system.
# To force log out a user use "pkill -u <<user_name>>"
# Check SElinux context for the each ssh config file.
# Check SElinux context of ~/.ssh directory if pub-key authentication is not working.
# Use "restorecon -R -v ~/.ssh" to restore SElinux context.
# Use "aureport" command if some one is brute forcing.


#######################################
# General SSH commands.

# To ssh into a system.
ssh <user_name>@<ip_address> or ssh -l <user_name> <ip_address>

# To specify another port number.
ssh -p <user_name>@<ip_address>

# To use remote server's private key to connect.
ssh -t KEY_FILE -l <user_name> <ip_address>

# To forward local port to the remote port of remote server to access another service on remote server without opening firewall in it.
ssh <user_name>@<remote_ip_address> -L <any_random_port>:<remote_loopback_address>:<target_port>

# To do reverse port forwarding, this allows to access local client remotely even firewall is enabled.
ssh -R <remote_port>:<remote_loopback_address>:<local_port> <user_name>@<remote_ip_address>

# To do dynamic port forwarding and creates SOCKS proxy on localhost.
ssh -D <port> <user_name>@<remote_ip_address>

# To compress a ssh connection.
ssh -l <user_name> -C <ip_address>

# To forward X11 server to client.
ssh -X -l <user_name> <ip_address>

# To run command with ssh on remote system and get output in client console.
ssh -l <user_name> <ip_address> "<command>;<command>"

# To get verbose output.
# This option can be used with above examples, one can increase verbosity by using upto three -vvv with ssh.
ssh -v -l <user_name> <ip_address>

# To save public key of client system in remote server authorized_keys file.
ssh-copy-id <user>@<ip_address>

# To save public key of client system in remote server authorized_keys file by using remote server's identity file.
ssh-copy-id -i <identity_file> <user>@<ip_address>

# -f for force option if already present there.
ssh-copy-id -f <user>@<ip_address>

# -p If remote server is using non-default port.
ssh-copy-id -p <port> <user>@<ip_address>

# to generate rsa ssh key of 4096 bits.
ssh-keygen -t rsa -b 4096

# -f for file name -p for password prompt.
ssh-keygen -f .\id_rsa -p

# To update a passphrase on a key.
# The below command can also be used to remove password.
ssh-keygen -p -P <old_passphrase> -N <new_passphrase> -f KEYFILE

# To add a comment in a key.
ssh-keygen -t rsa -b 4096 -C "COMMENT"

# To connect to a remote host through a SOCKS5 proxy.
# Use either "ncat" or "netcat" whichever is available.
ssh -o ProxyCommand="ncat --proxy-type socks5 --proxy 127.0.0.1:1080 %h %p" <user>@<ip_address>
ssh -o ProxyCommand="ncat --proxy-type socks5 --proxy 127.0.0.1:1080 %h %p" <user>@<ip_address> -p <port>


################# Sample /etc/ssh/sshd_config hardening ################
Port 2222
Protocol 2
X11Forwarding no
LogLevel INFO
IgnoreRhosts yes
MaxAuthTries 4
HostbasedAuthentication no
PermitRootLogin no
PermitUserEnvironment no
PermitEmptyPasswords no
Ciphers aes128-ctr,aes192-ctr,aes256-ctr
ClientAliveInterval 600
ClientAliveCountMax 0
Banner /etc/issue.net
Banner /etc/motd
AllowGroups root,wheel

# Never set PermitTTY no.

# To allow users from specific set of IPs.
# first wildcard means all users from that <ip_address>.
AllowUsers *@<ip_address>

# from a network.
AllowUsers *@<network_id>/<cidr

# Wildcards can also be used.
AllowUsers *@<ip_address>* 

# Restrict users from few IPs.
AllowUsers *@<ip_address> *@<ip_address> *@<ip_address>

# Restrict to a specific users from a IP.
AllowUsers <user_name>@<ip_address>
##############################################################################


##########################################################################################################
~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
# This file contains public keys of remote systems.
# This file must be with the permissions of 600.

<option> ssh-rsa AAAA... # This is the line where key starts the below options can be prepend to this line for keys in authorized_keys file.
no-user-rc ssh-rsa AAAA... # This is the line where key starts the below options can be prepend to this line for keys in authorized_keys file.

# This option executes command and logs out of the system.
# Can not use this option multiple times.
command="COMMAND;COMMAND" ssh-rsa AAAA... <-- This is for example only.

# Restricts agent forwarding.
no-agent-forwarding

# Restricts port forwarding.
no-port-forwarding

# Restricts excution of hosts rc file ~/.ssh/rc.
no-user-rc

# Restricts X11-forwarding.
no-X11-forwarding

# Allows port-forwarding is disabled in sshd_config.
port-forwarding

# Allows pty allocation if disabled.
pty

# Allow port-forwarding on specific ip and port.
permitopen="host:port"

# This option enables all restriction at once.
restrict
############################################################################################################


#################################################################################################
/etc/ssh/sshrc
# This is a system wide configuration file, which is not present by default.
# This file's all permissions must be on the root user and read by all the users on system.
# This file execute commands or script in it when someone logs in through ssh.

# Default permission set to 744.
chmod 744 /etc/ssh/sshrc


####################################################################################################
AUTOMATION IN SSH WITH PASSWORDLESS SETUP
*****************************************
dnf -y install sshpass

# USING NATIVE SSH TOOLS FOR PASSWORDLESS SETUP. #
ssh-keygen -b 4096 -t rsa
ssh-copy-id -p 2169 paul@10.0.0.171


# USING CURL #
cat > .netrc << EOF 
machine 10.0.0.171 login paul password Pa55wo&rd@lin#ux
EOF
  
curl -T "/home/paul/test.zip" sftp://paul@10.0.0.171:2169/home/paul/ --netrc-file .netrc

# Uses default .netrc file in users home directory.
curl -T "/home/paul/test.zip" sftp://paul@10.0.0.171:2169/home/paul/ -n



# USING SSHPASS UTILITY. #
sshpass -p 'Pa55wo&rd@lin#ux' ssh paul@10.0.0.171 -p 2169
sshpass -p 'Pa55wo&rd@lin#ux' scp -P 2169 test.zip paul@10.0.0.171:/home/paul/
sshpass -p 'Pa55wo&rd@lin#ux' sftp -P 2169 paul@10.0.0.171:/home/paul/


export SSHPASS='Pa55wo&rd@lin#ux'
sshpass -e scp -P 2169 /home/paul/test paul@10.0.0.171:/home/paul

export SSHPASS='Pa55wo&rd@lin#ux'
sshpass -e ssh paul@10.0.0.171 -p 2169

########################################################################
# echo 'machine <ip_address> login <user_name> password <password>' > .netrc

#!/bin/bash

usage () {
	echo "Usage: $0 <remote_user> <hostname> <port> <file> <destination>" >&2
	echo "$0: Sends a file to remote host without password." >&2
	exit 1
}

if [[ $# -lt 5 ]]; then
	usage
fi

if [[ ! -f ~/.netrc ]]; then
	echo "File .netrc does not exist in the home folder of $USER." >&2
	echo -e ".netrc file syntax.\n"
	echo "machine <ip_address> login <user_name> password <password>"
	exit 2
fi

remote_user="${1}"
remote_hostname="${3}"
remote_port="${4}"
full_file_path="${4}"
dest_path="${5}"

export remote_user remote_hostname remote_port full_file_path dest_path

if [[ -d "${full_file_path}" ]]; then
	echo "Directory provided!"
	echo "Please make an archive of the directory by zip or tar."
	exit 3
fi

# -n means use the ".netrc" file for credentials.
curl -T "${full_file_path}" sftp://"${remote_user}"@"${remote_hostname}":"${remote_port}""${dest_path}" -n
Commands -- ssh, sshd, sftp, scp, ssh-copy-id, ssh-keygen, w ,semanage
Packages openssh, openssh-server
Configuration files.
/etc/ssh/sshd_config, /etc/ssh/sshrc, ~/.ssh/rc, ~/.hushlogin, /etc/motd, ~/.authorized_keys

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
# To force log out a user use "pkill -u <user_name>"
# Check SElinux context for the each ssh config file.
# Check SElinux context of ~/.ssh directory if pub-key authentication is not working.
# Use "restorecon -R -v ~/.ssh" to restore SElinux context.
# Use "aureport" command if some one is brute forcing.


#######################################
# General SSH commands.

# To ssh into a system.
ssh USER_NAME@IP_ADDRESS or ssh -l USER_NAME IP_ADDRESS

# To specify another port number.
ssh -p USER_NAME@IP_ADDRESS

# To use remote server's private key to connect.
ssh -t KEY_FILE -l USER_NAME IP_ADDRESS

# To forward local port to the remote port of remote server to access another service on remote server without opening firewall in it.
ssh -L LOCAL_PORT:LOCALHOST_OF_REMOTE_SERVER:REMOTE_PORT USER_NAME@IP_ADDRESS_OF_REMOTE_SERVER

# To do reverse port forwarding, this allows to access local client remotely even firewall is enabled.
ssh -R REMOTE_PORT:LOCALHOST_OF_REMOTE_SERVER:LOCAL_PORT USER_NAME@IP_ADDRESS_OF_REMOTE_SERVER

# To do dynamic port forwarding and creates SOCKS proxy on localhost.
ssh -D PORT_NUMBER USER_NAME@IP_ADDRESS_OF_REMOTE_SERVER

# To compress a ssh connection.
ssh -l USER_NAME -C IP_ADDRESS

# To forward X11 server to client.
ssh -X -l USER_NAME IP_ADDRESS

# To run command with ssh on remote system and get output in client console.
ssh -l USER_NAME IP_ADDRESS "COMMAND;COMMAND"

# To get verbose output.
# This option can be used with above examples, one can increase verbosity by using upto three -vvv with ssh.
ssh -v -l USER_NAME IP_ADDRESS


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
# first wildcard means all users from that ip_address.
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

ssh-rsa AAAA... # This is the line where key starts the below options can be prepend to this line for keys in authorized_keys file.

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
	echo 'Sends file to remote host without password.' >&2
	exit 1
}

if [[ $# -lt 5 ]]; then
	usage
fi

if [[ ! -f ~/.netrc ]]; then
	echo "File .netrc does not exist in the home folder of $USER." >&2
	exit 2
fi

export remote_user="${1}"
export remote_hostname="${3}"
export remote_port="${4}"
export full_file_path="${4}"
export dest_path="${5}"

if [[ -d $ "${full_file_path}" ]]; then
	echo "Directory provided!"
	echo "Please make an archive of the directory by zip or tar."
	exit 3
fi

# -n means use the ".netrc" file for credentials.
curl -T "${full_file_path}" sftp://"${remote_user}"@"${remote_hostname}":"${remote_port}""${dest_path}" -n
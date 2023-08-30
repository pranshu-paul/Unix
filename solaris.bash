# Solaris quick reference sheet.

# To list Listening network sockets ipv4.
netstat -an -f inet | grep LISTEN

# System logs.
tail -f /var/log/syslog

# To send files through email in solaris.
# sendmail look for "mailhost" relay in /etc/hosts.
uuencode <file_name> <any_name> | sendmail -f <arbitrary_address> <recipient>

# Hosts file entry.
# Always set the below parameters even for the loopback address.
<ip_address> <fqdn> <hostname> <nickname>

# Lists hosts file.
getent hosts fclonedb

# Lists FQDN.
getent hosts $(hostname) | awk '{print $2}' | uniq

# To create a new user.
useradd -k /etc/skel/ -m paul

# Password
passwd paul

# Delete the password.
passwd -d paul

# List IP address.
ifconfig -a

# Lists connected and working NICs.
dladm show-phys

# To ping a host.
ping -s google.com

# Checks port.
nc -zv google.com 443
nc -zv -w 2 google.com 80,443
nc -zv -w 2 google.com 80-443

# Shows processor.
uname -p

# Shows nodename.
uname -n

# Shows architecture.
uname -m

# Shows total memory.
prtconf | grep Memory


# Vim
# Use Shift+Left-Click to select text in solaris.
# System wide configuration file /usr/share/vim/vimrc.



# To send emails from mutt.
echo "This is an email from Fineorganics Production." | mutt -s "Test Mail" "dba@rostantechnologies.com" -c "dba@rostantechnologies.com" -a /path/to/file /path/to/file


# The required configuration for mutt, in case using a mail relay.
cat << EOF > ~/.muttrc
set smtp_url = "smtp://mailsrv2.fineorganics.com:25"
set from = "prod_ebs@fineorganics.com"
set edit_headers=yes
set ssl_starttls = no
set ssl_force_tls = no
EOF
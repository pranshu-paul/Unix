

# To install arp.
yum -y install net-tools
# To check other users on interface ens33.
arp -i ens33

# An example of the output.
[root@rhel ~]# arp -i ens33
Address                  HWtype  HWaddress           Flags Mask            Iface
192.168.1.4              ether   e4:02:9b:0f:af:e1   C                     ens33
dsldevice.lan            ether   18:45:93:7d:ed:20   C                     ens33
10.0.0.2                 ether   00:0c:29:11:11:a2   CM                    ens33
192.168.1.5              ether   1c:bf:c0:8a:f4:a3   C                     ens33

# Flags Mask
# C = Complete entry
# M = Permanent entry
# P = Published entry






# To install authconfig.
yum -y install authconfig

# It automatically locks out the user whose password is entered incorrectly.
# Used pam module in this command is "pam_faillock".
# More faillockargs can be searched by looking into "man pam_faillock".
authconfig --enablefaillock --faillockargs="audit deny=3 unlock_time=3600 even_deny_root" --update

# To check that changes are made or not.
authconfig --test | grep pam_faillock

# To unlock a user.
faillock --user USERNAME --reset

# To set password min length.
authconfig --passminlen=12 --update

# To deny a user to repeat its password.
authconfig --passmaxrepeat=0 --update

# To set password algorithm to sha512sum.
authconfig --passalgo=sha512 --update

# Requires at least one lowercase in password.
authconfig --enablereqlower --update

authconfig --disablereqlower --update

# Requires at least one uppercase in password.
authconfig --enablerequpper --update

authconfig --disablerequpper --update

# Requires at least a number in password.
authconfig --enablereqdigit --update

authconfig --disablereqdigit --update

# Requires at least one special character.
authconfig --enablereqother --update

authconfig --disablereqother --update

# Creates and restores backup
authconfig --savebackup=PATH_TO_FILE
authconfig --restorebackup=PATH_TO_FILE

# To install awk.
yum -y install gawk

# Ensure only the root account has UID 0.
awk -F: '($3 == "0") {print}' /etc/passwd

# To list all users in system.
awk -F':' '{print $1}' /etc/passwd

# To install badblocks.
yum -y install e2fsprogs

# To install batch.
yum -y install at# To install bc.
yum -y install bc

# bg - background

# Move jobs to the background.

# Example

bg %1	# Sends the job, having Job ID ‘n’, to the background.

bg %%	# Sends the current job to the background.

bg %-	# Sends the previous job to the background.

bg %sleep 5	# Sends the job whose name starts with string to the background.

# Package for blkid is "util-linux".

# To check disk's block id.
blkid

# To install brctl.
yum -y install bridge-utils# To install bridge.
yum -y install iproute

# To install cal.
yum -y install util-linux

# To show this month calender.
cal

# To show year calender.
cal -y

# Package = "coreutils".

cat - concatenate files and print on the standard output

# To display which ip is executing which daemon remotely.
cat /var/log/audit/audit.log | awk '{print $12,$10}'| grep addr | sort | uniq -c | sort -n | less -X

# To display the contents of a file.
cat FILE

# To display file contents with line numbers.
cat -n FILE

# To display file contents with line numbers (blank lines excluded).
cat -b FILE


# Package = bash

# To change to the user's home directory.
cd
cd ~

# To change to the previous directory.
cd ..

# To change to the root node.
cd /

# To change to the previous working directory, "OLDPWD" shell variable.
cd -

# To change to the relative path of the directory.
cd ./


# To install chattr.
yum -y install e2fsprogs

# To install chcon.
yum -y install coreutils.



# To install cpio.
yum -y install cpio# Package = coreutils.



# To install cryptsetup.
yum -y install cryptsetup

cryptsetup - manage plain dm-crypt and LUKS encrypted volumes# To install curl.
yum -y install curl

# To check a ip's details.
curl ipinfo.io/"<ip_address>"

# For example.
curl ipinfo.io/8.8.8.8

# Package = coreutils

# To cut out the third field of text or stdoutput that is delimited by a #
cut -d# -f3

# To install date.
yum -y install coreutils

date

date +%D# To install dd.
yum -y install coreutils

# df - disk free
# Package = coreutils

# To check disk size in human readables format.
df -h

# To check device file system.
df -Th

# For a block device.
df -h /dev/sda

# For a mount point.
df -h /

# To install diff.
yum -y install diffutils

# To install dig.
yum -y install bind-utils

# To install dmesg.
yum -y install util-linux

# To install dmidecode.
yum -y install dmideocde

# To install du.
yum -y install coreutils

# Package = e2fsprogs

e2label /dev/BLOCK_DEVICE LABEL -- # To set label on ext4 drive.# To install egrep.
yum -y install grep

# Package for env is "coreutils".# To install ethtool.
yum -y install ethtool

# To install exportfs.
yum -y install nfs-utils

# To install faillock.	
# See authconfig
yum -y install pam

# To unlock a user.



# To install fdisk.
yum -y install util-linux

# To edit a drive or partition.
fdisk /dev/DRIVE

# To list all available drives.
fdisk -l | grep /dev/


# To install fgrep.
yum -y install grep

# To install file.
yum -y install file

# To install findmnt.
yum -y install util-linux

# To install find.
yum -y install findutils

# To find in current directory.
find . -name NAME

# To find in current directory and redirect error to /dev/null.
find . -name NAME 2>/dev/null

# To find from root node.
find / -name NAME

# To find directory.
# If name contains spaces use -name "NAME WITH SPACE"
find / -type d -name NAME

# To avoid looking into sub directories.
find / -name NAME -prune

# To allow find into max sub directories.
find / -name NAME -maxdepth 2

# To allow find into min sub directories.
# ignore results for first 4 directories.
find / -name NAME -mindepth 4

# To ignore case while finding.
find / -iname NAME

# To Delete files older than 30 Days in Linux.
find /home -type f -mtime +30 | xargs rm -f

# To find files with permissions.
find / -type f -perm 755 -print

# To find file without permissions.
find / -type f ! -perm 777 -print

# To find empty files.
find / -type f -empty

# To find with file size.
# M -- for megabyte, G -- for gigabyte, K -- for kilobyte
find / -size +5M

# To find file with modified time.
# find files more than a day ago but not more than 7 days.
# other options are -ctime -- change time, -atime -- access time.
find / -mtime +1 -mtime -7

# To avoid find for looking into other filesystems.
find / -name NAME -mount

# To execute command for out of find command.
find / -name NAME -exec COMMAND {} \;

find . -user orap -mtime 10 -exec rm {} \;

# To dlete a particular user owned files.
find . -user oracle -exec rm -fr {} \;

# To install finger.


yum -y install finger




Package = coreutils
fmt (1)              - simple optimal text formatter

# To install free.
yum -y install procps-ng

# To check memory status in human readable format.
free -h

# To install fsck.
yum -y install util-linux

# To install gcc.
yum -y install gcc

# To install gdisk.
yum -y install gdisk

# To install geoiplookup.
yum -y install GeoIP

# To install getenforce.
yum -y install libselinux-utils

# To install getent.
yum -y install glibc-common

# To install git.
yum -y install git

# To install gpg.
yum -y install gnupg2

# Create a key
gpg --gen-key


# Show keys

  To list a summary of all keys

    gpg --list-keys

  To show your public key

    gpg --armor --export

  To show the fingerprint for a key

    gpg --fingerprint KEY_ID

# Search for keys

  gpg --search-keys 'user@emailaddress.com'


# To Encrypt a File

  gpg --encrypt --recipient 'user@emailaddress.com' example.txt


# To Decrypt a File

  gpg --output example.txt --decrypt example.txt.gpg
  
  # Export keys

  gpg --output ~/public_key.txt --armor --export KEY_ID
  gpg --output ~/private_key.txt --armor --export-secret-key KEY_ID

  Where KEY_ID is the 8 character GPG key ID.

  Store these files to a safe location, such as a USB drive, then
  remove the private key file.

    shred -zu ~/private_key.txt

# Import keys

  Retrieve the key files which you previously exported.

    gpg --import ~/public_key.txt
    gpg --allow-secret-key-import --import ~/private_key.txt

  Then delete the private key file.

    shred -zu ~/private_key.txt

# Revoke a key

  Create a revocation certificate.

    gpg --output ~/revoke.asc --gen-revoke KEY_ID

  Where KEY_ID is the 8 character GPG key ID.

  After creating the certificate import it.

    gpg --import ~/revoke.asc



  Then ensure that key servers know about the revokation.

    gpg --send-keys KEY_ID

# Signing and Verifying files

#  If you're uploading files to launchpad you may also want to include
#  a GPG signature file.

    gpg -ba filename

  or if you need to specify a particular key:

    gpg --default-key <key ID> -ba filename

  This then produces a file with a .asc extension which can be uploaded.
  If you need to set the default key more permanently then edit the
  file ~/.gnupg/gpg.conf and set the default-key parameter.

  To verify a downloaded file using its signature file.

  gpg --verify filename.asc

# Signing Public Keys

  Import the public key or retrieve it from a server.

    gpg --keyserver <keyserver> --recv-keys <Key_ID>

  Check its fingerprint against any previously stated value.

    gpg --fingerprint <Key_ID>
	
	 Sign the key.

    gpg --sign-key <Key_ID>

  Upload the signed key to a server.

    gpg --keyserver <keyserver> --send-key <Key_ID>

# Change the email address associated with a GPG key

  gpg --edit-key <key ID>
  adduid

  Enter the new name and email address. You can then list the addresses with:

    list

  If you want to delete a previous email address first select it:

    uid <list number>

  Then delete it with:

    deluid

  To finish type:

    save

  Publish the key to a server:

    gpg --send-keys <key ID>
	
	# Creating Subkeys

#  Subkeys can be useful if you don't wish to have your main GPG key
#  installed on multiple machines. In this way you can keep your
#  master key safe and have subkeys with expiry periods or which may be
#  separately revoked installed on various machines. This avoids
#  generating entirely separate keys and so breaking any web of trust
#  which has been established.

    gpg --edit-key <key ID>

  At the prompt type:

    addkey

  Choose RSA (sign only), 4096 bits and select an expiry period.
  Entropy will be gathered.

  At the prompt type:

    save

  You can also repeat the procedure, but selecting RSA (encrypt only).
  To remove the master key, leaving only the subkey/s in place:

    gpg --export-secret-subkeys <subkey ID> > subkeys
    gpg --export <key ID> > pubkeys
    gpg --delete-secret-key <key ID>

  Import the keys back.

    gpg --import pubkeys subkeys

  Verify the import.
  
   gpg -K

  Should show sec# instead of just sec.

# High-quality options for gpg for symmetric (secret key) encryption

  This is what knowledgable people consider a good set of options for
  symmetric encryption with gpg to give you a high-quality result.

  gpg \
    --symmetric \
    --cipher-algo aes256 \
    --digest-algo sha512 \
    --cert-digest-algo sha512 \
    --compress-algo none -z 0 \
    --s2k-mode 3 \
    --s2k-digest-algo sha512 \
    --s2k-count 65011712 \
    --force-mdc \
    --pinentry-mode loopback \
    --armor \
    --no-symkey-cache \
    --output somefile.gpg \
    somefile # to encrypt

  gpg \
    --decrypt \
    --pinentry-mode loopback \
    --armor \
    --output somefile.gpg \
    somefile # to decrypt# To install grep.
yum -y install grep

-i -- ignore case
-e -- extended grep
-f -- fixed grep 



# To install groupadd.
yum -y install shadow-utils


# To install groupdel.
yum -y install shadow-utils



# To install grub2-mkconfig.
yum -y install grub2-tools

# Package for grub2-setpassword is "grub2-tools-minimal".
# Package for grubby is "grubby"

# To install gcc-c++.
yum -y install gcc-c++

# To install gzip.
yum -y install gzip

# To install hdparm.
yum -y install hdparm

# Package for head is "coreutils".

# To install hostnamectl.
yum -y install systemd

# To install hostname.
yum -y install hostname

# To install host.
yum -y install bind-utils

# To install id.
yum -y install coreutils

# To install ifconfig.
yum -y install net-tools



# To install ip6tables.
yum -y install iptables

# To install iptables.
yum -y install iptables

# To install ip.
yum -y install iproute



# To install kexec.
yum -y install kexec-tools

# To install killall.
yum -y install psmisckill 

PID

kill 0

To kill forcefully.
kill -9 PID
# Package = shadow-utils



# To install last.
yum -y install sysvinit-tools

# To install ldd.
yum -y install glibc-common

# To install less.
yum -y install less

# To disable the terminal refresh when exiting.
less -X

# Package for ln is "coreutils".

# To install localectl.
yum -y install systemd



# To install locate.
yum -y install mlocate



# To install lpr.
yum -y install cups-client

# Package = e2fsprogs

# To install lsblk.
yum -y install util-linux

lsblk -- # List all block devices.

lsblk -f # List all block devices with their file systems.

# To install lscpu.
yum -y install util-linux

lscpu

# lshw - list hardware

# To install lshw.
yum -y install lshw



# To install lsof.
yum -y install lsof

# To install lspci.
yum -y install pciutils

# ls - list 

# Package = "coreutils".

# List directory contents.
ls

# Long listing of directory contents.
ls -l

# List directory size in human readable format.
# This option works with [-l] option only.
ls -lh

# List hidden files and directory.
ls -a

# List SElinux context.
ls -lZ

# To install lsusb.
yum -y install usbutils

# To install ltrace.
yum -y install ltrace


# To install lvm.
yum -y install lvm2


# To install make.
yum -y install make

# To install man.
yum -y install man-db

# To install mdadm.
yum -y install mdadm

# To install mkfs.
yum -y install util-linux

mkfs.ext4 /dev/DRIVE -- # To make a ext4 file system.
mkfs.ext4 /dev/DRIVE -F -- # To make ext4 with force.

# To install mkswap.
yum -y install util-linux

mkswap /dev/BLOCK_DEVICE -- # To create a swap partition.

# To install modprobe.
yum -y install kmod

# To install mount.
yum -y install util-linux

# To install mpstat.
yum -y install sysstat

# To install mtr.
yum -y install mtr

# To install mutt.
yum -y install mutt


# To run mutt first we need to set up mutt configuration file.
# Default folder for mutt is ~/.muttrc

# Here is a sample configuration file(.muttrc).

# Port for imap = 993 and smtp = 587

# set folder = "imaps://testing.paulpranshu@gmail.com@imap.gmail.com:993"
# set spoolfile = "+INBOX"
# set smtp_url = "smtp://testing.paulpranshu@gmail.com@smtp.gmail.com:587"
# set smtp_pass = "PASSWORD"
# set imap_pass = "PASSWORD"
# set from = "testing.paulpranshu@gmail.com"
# set realname = "Pranshu Paul"


# To send email from command line.
# -s SUBJECT -c CARBON COPY -b BLIND CARBON COPY -a ATTACHMENT
# echo MESSAGE | mutt -s "SUBJECT" -c CARBON COPY -b BLIND CARBON COPY MAIL RECIPIENT -a # PATH TO ATTACHMENT
echo Hello | mutt -s "Test mail" -c someone@somwhere.com -b someone2@somwhere.com someone3@somwhere.com -a /etc/os-release

# HereDoc can be also use a message writing for email.
cat << HereDoc mutt -s "Mutt" someone@somwhere.com
Message can be type in this format.
This is a email.
HereDoc

# Commands output can be also send as stdin to mutt.
nmcli dev status | mutt -s "Mutt" someone@somwhere.com

# To install nc.
yum -y install nmap-ncat

# To install netstat.
yum -y install net-tools


# To see which ip is trying to scan.
netstat -ntu | awk '{print $5}' | sort | uniq -c | sort -n


# To see what connections are coming in from the same subnet (/16).
netstat -ntu|awk '{print $5}'|cut -d: -f1 -s |cut -f1,2 -d'.'|sed 's/$/.0.0/'|sort|uniq -c|sort -nk1 -r

# To find connections from the /24 subnet, the command would be.
netstat -ntu|awk '{print $5}'|cut -d: -f1 -s |cut -f1,2,3 -d'.'|sed 's/$/.0/'|sort|uniq -c|sort -nk1 -r

# List all IP addresses which have connected to the server.
netstat -anp |grep 'tcp\|udp' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c

# To calculate and count the number of connections each IP address makes to your server.
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n

# To install nice.
yum -y install coreutils

Package = coreutils
nl (1)               - number lines of files

# To install nmap.
yum -y install nmap

# To install nmcli.
yum -y install NetworkManager

# To install nmtui.
yum -y install NetworkManager-tui

# To install nohup.
yum -y install coreutils

# To install numastat.
yum -y install numactl

# To install openssl.
yum -y install openssl

# To create a 2048-bit private key:
openssl genrsa -out server.key 2048

# To create the Certificate Signing Request (CSR):
openssl req -new -key server.key -out server.csr

# To sign a certificate using a private key and CSR:
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# (The above commands may be run in sequence to generate a self-signed SSL certificate.)

# To show certificate information for a certificate signing request
openssl req -text -noout -in server.csr

# To show certificate information for generated certificate
openssl x509 -text -noout -in server.crt

# To get the sha256 fingerprint of a certificate
openssl x509 -in server.crt -noout -sha256 -fingerprint

# To view certificate expiration:
echo | openssl s_client -connect <hostname>:443 2> /dev/null | \
awk '/-----BEGIN/,/END CERTIFICATE-----/' | \
openssl x509 -noout -enddate

# To generate Diffie-Hellman parameters:
openssl dhparam -outform PEM -out dhparams.pem 2048

# High-quality options for openssl for symmetric (secret key) encryption

This is what knowledgable people consider a good set of options for
symmetric encryption with openssl to give you a high-quality result.
Also, always remember that the result is only as good as the password
you use. You must use a strong password otherwise encryption is meaningless.

# To view certificate expiration:
echo | openssl s_client -connect <hostname>:443 2> /dev/null | \
awk '/-----BEGIN/,/END CERTIFICATE-----/' | \
openssl x509 -noout -enddate

# To generate Diffie-Hellman parameters:
openssl dhparam -outform PEM -out dhparams.pem 2048

# High-quality options for openssl for symmetric (secret key) encryption

This is what knowledgable people consider a good set of options for
symmetric encryption with openssl to give you a high-quality result.
Also, always remember that the result is only as good as the password
you use. You must use a strong password otherwise encryption is meaningless.


  
  # To install parted.
yum -y install util-linux

# Package = parted
partprobe - inform the OS of partition table changes

# To show a summary of devices and their partitions.
partprobe -s

# To install passwd.
yum -y install passwd

# To change your own password.
passwd

# To change a users password(works only with sudo or root).
passwd <user_name>

# To locks out a users password.
passwd -l <user_name>

# To unlocks a users password.
passwd -u <user_name>

# To automate a users password change without being prompted.
echo PASSWORD | passwd --stdin <user_name>

echo $RANDOM $RANDOM | sha512sum | head -c 16 | passwd --stdin <user_name>

# To install pax.
yum -y install pax

# To install ping.
yum -y install iputils

# To install pmap.
yum -y install procps-ng

# To install pstree.
yum -y install psmisc

# To install ps.
yum -y install procps-ng

ps -aux -- all processes from user x

ps -ef -- all processes in ASCII format.

# ps -au USER
ps -au pranshu

ps -C COMMAND -- searches command PID

ps -ef | awk '{print $2 ',' $8}' | less -- to see only PID and command.

# To install pwd.
yum -y install coreutils



Package for renice util linux.

# To install resize2fs.
yum -y install e2fsprogs

# To install restorecon.
yum -y install policycoreutils

# To install route.
yum -y install net-tools

# To install rpm.
yum -y install rpm

# To install rsync.
yum -y install rsync



# To install sar.
yum -y install sysstat

# To install scp.
yum -y install openssh-clients



# To install sealert.
yum -y install setroubleshoot-server setroubleshoot

# To install sed.
yum -y install sed

# To install semanage.
yum -y install policycoreutils-pythonapt install postfix

nmcli d s | sendmail -F Pranshu Paul paulpranshu@gmail.com

# To install sensors.
yum -y install lm_sensors

# To install setfacl.
yum -y install acl

setfacl --modify user:<user>:<perms> <file>
setfacl --modify user:opc:rw test

# Removing all ACLs.
setfacl -b <file>

# To install setsebool.
yum -y install policycoreutils

# To install sftp.
yum -y install openssh-clients

# To connect a remote system for data transfer.
# -a attempt to resume file transfer if interreputed.
sftp USER_NAME@IP_ADDRESS

# To connect a remote system for data transfer with different port.
sftp -P USER_NAME@IP_ADDRESS

# To login into a specific path.
sftp USER_NAME@IP_ADDRESS:/PATH/TO/DIRECTORY

# To fetch file directly.
sftp USER_NAME@IP_ADDRESS:/PATH/TO/FILE

# To use remote server identity file.
sftp -i PRIVATE_KEY USER_NAME@IP_ADDRESS

# To preserve files modificate time.
sftp -p USER_NAME@IP_ADDRESS

# To upload file from windows machine.
# After login into sftp.
# -r option to put recursively with folder only.
# -a option to resume if got interreputed.
put c:\PATH\TO\FILE /REMOTE/PATH

# To upload file from linux machine.
put /LOCAL/PATH /REMOTE/PATH

# To get file into windows machine.
# -r option to put recursively with folder only.
# -a option to resume if got interreputed.
get /REMOTE/PATH c:\PATH\TO\FILE

# To get file into linux machine.
get /REMOTE/PATH /LOCAL/PATH

# use bye command to get out of the prompt.


# To install showmount.
yum -y install nfs-utils

# To install smbclient.
yum -y install samba-client

# To install sort.
yum -y install coreutils

# To install sosreport.
yum -y install sos

sosreport

# To install ssh-copy-id.
yum -y install openssh-clients



# To install sshd.
yum -y install openssh-server.
configuration file /etc/ssh/sshd_config

# To test configuration.
sshd -T

# To install ssh-keygen.
yum -y install openssh openssh-clients



# To install ssh client.
yum -y install openssh-clients



# To install ssm.
yum -y install system-storage-manager

# To install ss.
yum -y install iproute

# To check which ip's are scanning.
ss -nHtu | awk '{print $6}'

# To install stat.
yum -y install coreutils


# To install strace.
yum -y install strace
Trace system calls.

# To install subscription-manager.
yum -y install subscription-manager

subscription-manager

# To attach a new subscription if there is no attached.
subscription-manager register --auto-attach
subscription-manager register --username <user_name> --password <password> --auto-attach

# To attach subscription if it's already attached.
subscription-manager register --auto-attach --force

# To check subscription id.
subscription-manager identity

# To install sudo.
yum -y install sudo

# To install su.
yum -y install util-linux

# To run command as second user.
su - USER -c '<command>'
su - paul -c 'ls -la'


# Package = util-linux
swapoff /dev/BLOCK_DEVICE -- # To disbale swap space.

# To install swapon.
yum -y install util-linux
swapon /dev/BLOCK_DEVICE -- # To enable swap on a block device.
swapon -s -- # To list enabled swap spaces.
swapon -a -- # To mount swap space when noauto option is provided in /etc/fstab.# To install sysctl.
yum -y install procps-ng




Package for taskset is util-linux.

# To install tcpdump.
yum -y install tcpdump

# To install teamdctl.
yum -y install teamd

# To install tee.
yum -y install coreutils

# To install timedatectl.
yum -y install systemd



# To install tmux.
yum -y install tmux

ctrl+b , shift+% -- To split a window vertically.
#ctrl+b , shift+" -- To split a window horizontally.
ctrl+b , up,down left,right -- To navigate between windows.

# To install top.
yum -y install procps-ng


# To display linux processes.


# To install traceroute.
yum -y install traceroute

# To install tree.
yum -y install treePackage = coreutils
tr (1)               - translate or delete characters

# To install tuna.
yum -y install tuna

# Package = bash

# Package for umount is "util-linux".

# To install uname.
yum -y install coreutils

# To install uniq.
yum -y install coreutils

# To install uptime.
yum -y install procps-ng



# To install useradd.
yum -y install shadow-utils



#

# To install userdel.
yum -y install shadow-utils

# To delete a user.
userdel USER_NAME



# To install usermod.
yum -y install shadow-utils



# To install vim.
yum -y install vim-enhanced vim-common

# To install vipw.
yum -y install shadow-utils

# To edit /etc/passwd file.
vipw

# To edit /etc/shadow file.
vipw -s

# To edit /etc/groups file.
vipw -g

# To install virsh.
yum -y install libvirt-client





# To install vmstat.
yum -y install procps-ng

# To install wall.
yum -y install sysvinit-tools

# To install watch.
yum -y install procps-ng

# To install wc.
yum -y install coreutils

# To install wget.
yum -y install wget

# To install whereis.
yum -y install util-linux

# To install which.
yum -y install which

# To install whoami
yum -y install coreutils

# To install who.
yum -y install coreutils

# To install w.
yum -y install procps-ng

# To install xargs.
yum -y install findutils


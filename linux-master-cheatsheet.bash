alias

# To set shortcuts to commands.

alias random-keyword="COMMAND WITH ATTRIBUTES"

Example

alias ll="ls -alF"

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

# To install at.
yum -y install at

# To schedule a one time task.
# Options for timing are.
# now | midnight | noon | teatime
# at now | at midnight etc.

# For example.
	at 14:30
# Output.
at>date
at>hostnamectl
at>Ctrl-d

# To list pending jobs.
atq

# Sample output of atq.
4       Fri Aug 27 21:56:00 2021 a root
# 4 is the job id.

# To remove a job (use id from atq)
atrm 4# To install auditctl.
yum -y install audit

# To enable auditctl.
systemctl enable --now auditd

# List audit rules.
auditctl -l

# To report the status of audit system.
auditctl -s

# To delete all rules.
auditctl -D

# To define a file system rule, use the following syntax.
# auditctl -w PATH_TO_FILE -p PERMISSIONS -k KEY_NAME

# permission types.
# r — read access to a file or a directory.
# w — write access to a file or a directory.
# x — execute access to a file or a directory.
# a — change in the file's or directory's attribute.

#  -k KEY_NAME can be a arbitrary name.# To install aureport.
yum -y install audit

# To check audit report.
aureport# To install ausearch.	# see auditctl
yum -y install audit

# To search from defined auditing rules from "auditctl".
ausearch -k KEY_STRING

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
awk -F':' '{ print $1}' /etc/passwd

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
# To install chage.
yum -y install shadow-utils

# To list a users details.
chage -l USER_NAME

# To set a users password min and max expiry date.
# -m min days, -M max days.
chage -m 90 -M 100 paul

# To set account expiry date.
chage -E 1-JAN-2022 USER_NAME

# To install chattr.
yum -y install e2fsprogs

# To install chcon.
yum -y install coreutils.

# To install chgrp.
yum -y install coreutils

# Package = coreutils
chmod - change file mode bits

# Roles
#u - user (owner of the file)
#g - group (members of file's group)
#o - global (all users who are not owner and not part of group)
#a - all (all 3 roles above)

# Numeric representations
7 - full (rwx)
6 - read and write (rw-)
5 - read and execute (r-x)
4 - read only (r--)
3 - write and execute (-wx)
2 - write only (-w-)
1 - execute only (--x)
0 - none (---)

# Set user to read/write/execute to (myscript.sh), octal notation.
chmod 755 myscript.sh

# Remove read/write/execute from (myscript.sh), symbolic mode.
chmod = myscript.sh

# Set user to read/write/execute, and group and others to read only permission to (myscript.sh), symbolic mode.

chmod u=rwx, go=r myscript.sh

# Package = coreutils
chown - change file owner and group

# To change a file's owner.
chown USER FILE

# To change a file's owner and group:
chown USER:GROUP FILE

# To change a directory's owner recursively:
chown -R USER DIRECTORY

# To change ownership to match another file:
chown --reference=REFERENCE-FILE FILE

# To install clear.
yum -y install ncurses

# To install cpio.
yum -y install cpio# Package = coreutils.

# To install crontab.
yum -y install cronie

# crontab format
* * * * *  command_to_execute
- - - - -
| | | | |
| | | | +- day of week (0 - 7) (where sunday is 0 and 7)
| | | +--- month (1 - 12)
| | +----- day (1 - 31)
| +------- hour (0 - 23)
+--------- minute (0 - 59)

# To install cryptsetup.
yum -y install cryptsetup

cryptsetup - manage plain dm-crypt and LUKS encrypted volumes# To install curl.
yum -y install curl

# To check a ip's details.
curl ipinfo.io/"IP_ADDRESS"

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
faillock --user USERNAME --reset


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


# To install firewall-cmd.
# firewall-cmd uses netfilter at its backend.
yum -y install firewalld

# List all current rules and ports defined.
firewall-cmd --list-all

# Firwall default behaviour.
# targets available ACCEPT, DROP, REJECT
firewall-cmd --permanent --set-target=DROP

# To add a new port.
# This option adds port immediatley, but removes port after reboot.
# The below option is an example of stateless rule.
firewall-cmd --add-port=<port>/<protocol>

# To make changes persistant.
# This option doesn't let you to add port immediatley.
# The below option is an example of stateless firewall.
firewall-cmd --add-port=<port>/<protocol> --permanent

# Use this option after [--permanent] option.
firewall-cmd --reload

# To add rich rule. (until next reboot)
# family type ipv6 ipv4.
# Options for rules {accept|reject|drop}.
firewall-cmd --add-rich-rule='rule family="ipv4" source address="IP_ADDRESS[/CIDR]" accept'

# To add a persistant rich rule.
# The below rules are examples of stateful firewall.
firewall-cmd --add-rich-rule='rule family="ipv4" source address="<ip_address>[/<cidr>]" accept' --permanent
firewall-cmd --add-rich-rule='rule family="ipv4" port port="8080" protocol="tcp"  source address="192.168.64.1" accept' --permanent
firewall-cmd --reload

# To remove rich-rule.
# Must be same as added.
firewall-cmd --remove-rich-rule='rule family="ipv4" source address="IP_ADDRESS" accept'

--add-forward-port=port=<portid>:proto=tcp:toport=<portid>[:toaddr=<address>[/mask]]
firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=8080:toaddr=10.0.0.45

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

# Ignores case while searching.
grep -i STRING

# Can search multiple STRINGs.
grep -e STRING1 -e STRING2 ...


# Looks for exact STRING only.
grep -f STRING

# Remove comments from a file and spaces.
grep -v -e '^#' -e '^$' <file> | column -t

# To install groupadd.
yum -y install shadow-utils

# To add a group.
groupadd GROUP_NAME

# To add a group with GID.
groupadd -g GID GROUP_NAME

# To install groupdel.
yum -y install shadow-utils

# To delete a group.
groupdel GROUP_NAME# To install groupmod.
yum -y install shadow-utils

# To change a group name.
groupmod -n NEW_GROUP_NAME OLD_GROUP_NAME

# To change a group GID.
groupmod -g GID GROUP_NAME

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

# To install iostat.
yum -y install sysstat

%user -- shows percentage of CPU utilization at user level.
%nice -- shows process priorities [-20 is highest, 0 is default, +19 is lowest.]
%system -- shows utilization at kernel.
%iowait -- shows CPUs waiting time when system has outstanding disk usage.
%steal -- involuntary wait by CPUs while hypervisior was servicing another virtual processor.
%idle -- shows how much percent CPU is in idle state.

tps -- transfer per second.

# To check CPUs I/O status.
iostat -c

# To check all I/O status in megabytes per second.
iostat

# To check a specific device I/O.
iostat -x DEVICE_NAME
iostat -x sda

# To install ip6tables.
yum -y install iptables

# To install iptables.
yum -y install iptables

# To install ip.
yum -y install iproute

# Package = systemd
journalctl - Query the systemd journal

# To show all collected log.
journalctl

# To actively follow log (like tail -f).
journalctl -f

# To show only kernel messages.
journalctl -k

# Shows one line messages, newest first.
journalctl -o short -r

# List number of boots.
journalctl -r --list-boots

# Search for the exact string.
journalctl -r -t

# To check logs for sshd.
journalctl -f -t sshd

# To check journals disk usage.
journalctl --disk-usage

# To display follow log of specific service.
journalctl -f -u ssh

# To filter by specific User ID e.g., user id 1000.
journalctl _UID=1000

# To check logs made by an executable.
journalctl -r /PATH/TO/EXECUTABLE

# To check n number of line.
journalctl -n N

# To check priority wise.
# ebug (7), info (6),
# notice (5), warning (4), err (3), crit (2), alert (1), and emerg (0).
journalctl -p

# To check logs from specific date.
journalctl -S "2020-10-30 18:17:16"# To install kexec.
yum -y install kexec-tools# To install killall.
yum -y install psmisckill PID

kill 0

To kill forcefully.
kill -9 PID
# Package = shadow-utils

# To check last log for root -u = user.
lastlog -u root

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

localectl status

# To set keymap to English India.
localectl set-keymap en_IN

# To install locate.
yum -y install mlocate

# To install logger.
yum -y install util-linux

logger -t TAG "MESSAGE"

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

# List all hardware details.
lshw | less

# List less details of hardware.
lshw -short | less

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



pvs -- # Brief display for physical volumes.
pvdisplay -- # To display physical volumes.
pvcreate /dev/BLOCK_DEVICE -- # To create a physical volume.
pvremove /dev/BLOCK_DEVICE -- # To remove a physical volume.


vgs -- # Brief display for volume groups.
vgcreate VOLUME_GROUP_NAME /dev/PHYSICAL_VOLUME_CREATED -- # To create a volume group.
vgextend VOLUME_GROUP_NAME /dev/NEW_PHYSICAL_VOLUME_CREATED -- # To extend a volume group.
vgreduce VOLUME_GROUP_NAME /dev/PHYSICAL_VOLUME_WHICH_WANT_TO_REMOVE -- # To remove a physical volume from a volume group.
vgremove VOLUME_GROUP_NAME -- # To remove a volume group.

lvs -- # Brief display for logical volume.
lvcreate --size 5G --name NAME_STRING VG_GROUP_NAME -- #  To create a logical volume. [-L|--size] [-n|--name]
lvdisplay -- # To display logical volumes.
lvextend --size +1G /dev/VG_GROUP_NAME/LOGICAL_VOLUME -- # To extend a logical volume. [-L|--size]
lvresize --size -1G /dev/VG_GROUP_NAME/LOGICAL_VOLUME -- # To resize a logical volume. [-L|--size]
lvremove /dev/VG_GROUP_NAME/LOGICAL_VOLUME -- # To remove a logical volume.
lvrename /dev/VG_GROUP_NAME/LOGICAL_VOLUME_OLD_NAME /dev/VG_GROUP_NAME/LOGICAL_VOLUME_NEW_NAME

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

openssl enc -e -aes-256-cbc \
  -salt \
  -pbkdf2 \
  -iter 1000000 \
  -md sha512 \
  -base64 \
  -in somefile \
  -out somefile.enc # to encrypt

openssl enc -d -aes-256-cbc \
  -salt \
  -pbkdf2 \
  -iter 1000000 \
  -md sha512 \
  -base64 \
  -in somefile.enc \
  -out somefile # to decrypt# To install parted.
yum -y install util-linux# Package = parted
partprobe - inform the OS of partition table changes

# To show a summary of devices and their partitions.
partprobe -s

# To install passwd.
yum -y install passwd

# To change your own password.
passwd

# To change a users password(works only with sudo or root).
passwd USER_NAME

# To locks out a users password.
passwd -l USER_NAME

# To unlocks a users password.
passwd -u USER_NAME

# To automate a users password change without being prompted.
echo PASSWORD | passwd --stdin USER_NAME

echo $RANDOM $RANDOM | sha512sum | head -c 16 | passwd --stdin USER_NAME

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

# To install pwmake.
yum -y install libpwquality

# To generate a password.
pwmake 64

# To change a users password with prompted.
pwmake 64 | passwd --stdin USER_NAME

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

# ssh public keys also work with rsync.

-a -- archive						#--max-size='200k' -- to specify file's maximum size
-v -- verbose						#--progress -- to show progress while transfer
-z -- compress						#--include 'R*' -- include all files starting with R
-h -- human readable				#--exclude '*' -- exclude all other files and folder
-e -- specify remote shell to use	#--remove-source-files -- removes source file after transfer
-n -- performs a dry run before transfer
-r -- recursive


# To copy files from this server to remote server.
rsync -avzh /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To copy remote directory files to this local server.
rsync -avhz USER_NAME@IP_ADDRESS:/PATH/OF/REMOTE_SERVER /PATH/OF/LOCAL_SERVER

# If want to use specific protocol for transfer {ssh}.
rsync -avzhe ssh /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To show progress while transfer.
rsync -avzhe ssh --progress /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To specify files and folder while transfer.
rsync -avhez ssh --include 'R*' --exclude /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To remove source files after success full transfer.
rsync --remove-source-files -azvh /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To copy remote directory files to this local server from ssh.
rsync -avzhe ssh USER_NAME@IP_ADDRESS:/PATH/OF/REMOTE_SERVER /PATH/OF/LOCAL_SERVER

# To specify options with ssh.
rsync -avzhe "ssh -p PORT"  /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To put restriction on bandwith limit. {1024 KB/s}
rsync -avzhe "ssh -p PORT" --bwlimit=1024  /PATH/OF/SOURCE USER_NAME@IP_ADDRESS:/PATH/TO/DESTINATION

# To install sar.
yum -y install sysstat

# To install scp.
yum -y install openssh-clients

# To upload a file onto a remote server.
scp /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To upload file from windows machine.
scp C:\Users\Pranshu\.ssh\id_rsa.pub 192.168.1.16:/home/pranshu/

# To get a file from remote server.
scp USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER /DESTINATION

# To use another port.
scp -P PORT /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To compress a connection.
scp -C /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To use remote server identity file.
scp -i IDENTITY_FILE /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To preserver modification time.
scp -p /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

# To get verbose output, can also increase verbosity by -vvv.
scp -v /PATH/TO/LOCAL_FILE USER@IP_ADDRESS:/PATH/TO/REMOTE_SERVER/DESTINATION

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

# To save public key of client system in remote server authorized_keys file.
ssh-copy-id USER@IP_ADDRESS

# To save public key of client system in remote server authorized_keys file by using remote server's identity file.
ssh-copy-id -i IDENTITY_FILE USER@IP_ADDRESS

# -f for force option if already present there.
ssh-copy-id -f USER@IP_ADDRESS

# -p If remote server is using non-default port.
ssh-copy-id -p USER@IP_ADDRESS# To install sshd.
yum -y install openssh-server.
configuration file /etc/ssh/sshd_config

# To test configuration.
sshd -T

# To install ssh-keygen.
yum -y install openssh openssh-clients

# to generate rsa ssh key of 4096 bits.
ssh-keygen -t rsa -b 4096

# -f for file name -p for password prompt.
ssh-keygen -f .\id_rsa -p

# To update a passphrase on a key:
ssh-keygen -p -P OLD-PASSPHRASE -N NEW-PASSPHRASE -f KEYFILE

# To add comment in a key.
ssh-keygen -t rsa -b 4096 -C "COMMENT"

# To install ssh client.
yum -y install openssh-clients

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
subscription-manager register --username USER_NAME --password PASSWORD --auto-attach

# To attach subscription if it's already attached.
subscription-manager register --auto-attach --force

# To check subscription id.
subscription-manager identity

# To install sudo.
yum -y install sudo

# To install su.
yum -y install util-linux

# To run command as second user.
su - USER -c 'COMMAND'
su - paul -c 'ls -la'


# Package = util-linux
swapoff /dev/BLOCK_DEVICE -- # To disbale swap space.

# To install swapon.
yum -y install util-linux
swapon /dev/BLOCK_DEVICE -- # To enable swap on a block device.
swapon -s -- # To list enabled swap spaces.
swapon -a -- # To mount swap space when noauto option is provided in /etc/fstab.# To install sysctl.
yum -y install procps-ng

# systemctl - systemctl control
# Package = systemd

# To list all services with description.
# -a=all -t=type
systemctl -at service

# To list all targets.
systemctl -at target

# To get list of enabled units.
systemctl list-unit-files --state=enabled

# To start and enable a service or socket.
systemctl enable --now SERVICE|SOCKET

# To change systemctl target.
systemctl isolate multi-user-target

# To change default target.
systemctl set-default graphical.target

# To check which is the current default target.
systemctl get-default

# To change into rescue target.
systemctl emergency

# To reboot, shutdown, hibernate.
systemclt {reboot|poweroff|hibernate}

# To view a unit file.
systemctl cat sshd

# To override a unit file.
systemctl edit SERVICE|SOCKET

# To list failed services.
systemctl list-units --state failed --type service
# Package for tail is "coreutils".# To install tar.													
																	c -- create
yum -y install tar													v -- verbose
																	z -- gzip
																	f -- use archive file

# To create a compressed tar.
tar cvzf TAR_NAME_.tar.gz FOLDER_NAME

# To extract tar.
tar xzvf TAR_NAME_.tar.gz

# To list content of a tar.
tar tvf TAR_NAME_.tar.gz

# To update a tar contents.
gunzip TAR_NAME_.tar.gz						-- First decompresses .gz
tar uf TAR_NAME_.tar FILE_OR_FOLDER_NAME	-- Updating tar
gzip TAR_NAME_.tar							-- Again compressing


# To delete contents from a compress.
gunzip TAR_NAME_.tar.gz
tar cvf TAR_NAME_.tar FILE_OR_FOLDER_NAME --remove-files
gzip TAR_NAME_.tarPackage for taskset is util-linux.

# To install tcpdump.
yum -y install tcpdump

# To install teamdctl.
yum -y install teamd

# To install tee.
yum -y install coreutils

# To install timedatectl.
yum -y install systemd

# To check time with date.
timedatectl status

# To set timezone Asia/Kolkata.
timedatectl set-timezone Asia/Kolkata

# To install tmux.
yum -y install tmux

ctrl+b , shift+% -- To split a window vertically.
#ctrl+b , shift+" -- To split a window horizontally.
ctrl+b , up,down left,right -- To navigate between windows.

# To install top.
yum -y install procps-ng


# To display linux processes.
top

# top -u USER
top -u pranshu|UID

# top -o option.
top -o %CPU
top -o VIRT
top -o $MEM -- highest memory usage at top.

# To monitor a PID ONLY.
top -p PID

# top internal commands(keyboard shortcuts).
E -- for changing memory unit to Mi, Gi, Ti, from Ki
f or F -- to change display fields.
k -- to kill a process by entering PID. press Esc to exit out of the promtp.
H -- for changing CPU mode to threads mode.
r -- to change process priority -- nice value [-20 is highest, 0 is default, +19 is lowest.]
m -- to change memory value to bar graph. -- b for bold.
1 -- to change CPU view from 1 to as logical CPUs.
u -- for changing view to user specific.

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
uptime -p


# To install useradd.
yum -y install shadow-utils



# To create a new user.
useradd USER_NAME

# UID, GID 100 - 999 are reserved for administartors.
# -c COMMENT, -g GID,-m creates home directory, -r creates system user, -s login sheel, -u UID
useradd -c Administrator -m -r -s /bin/bash -u 201 pranshu

# add user with a expiry date.
useradd -e YYYY-MM-DD USER_NAME

# -g primary group -G supplementry group -u UID 
useradd -g oinstall -G dba -u 2000 USER_NAME

# To install userdel.
yum -y install shadow-utils

# To delete a user.
userdel USER_NAME

# To delete a user recursively with home directory.
userdel -r USER_NAME

# To install usermod.
yum -y install shadow-utils

# To set a user group to wheel group.
usermod -aG wheel USER_NAME

# To allow a user check journals of system.
usermod -aG adm USER_NAME

# To change a users login name.
usermod -l OLD_LOGIN_NAME NEW_LOGIN_NAME

# To change a users shell.
usermod -s /bin/bash USER_NAME

# To change a users description.
usermod -c 'DESCRIPTION' 'USER_NAME'

# To change a users group.
# This removes the user from its current group.
usermod -g GROUP_NAME USER_NAME

# To add a user into a group with overriding previous.
usermod -aG GROUP_NAME USER_NAME

# Locks out the user.
usermod -L USER_NAME

# Unlocks the user.
usermod -U USER_NAME

# To set expiry date of a user account.
usermod --expiredate YYYY-MM-DD USER_NAME

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

# To install visudo.
yum -y install sudo

# sudo configuration file.
/etc/sudoers

# If directly editing /etc/sudoers file.
# Use below command to check syntax is correct or not.
visudo -c


# format
# user host=(users) [NOPASSWD:]commands
# also need to add to group.
# % - indicates group names

# %group host=(users) [NOPASSWD:]commands
%pranshu ALL=(ALL) NOPASSWD: /usr/bin/yum, NOPASSWD: /usr/sbin/aureport, PASSWD: /usr/bin/systemctl

# Instead giving full access to commands, only few options can also be provided.
%pranshu ALL=(ALL) NOPASSWD: /usr/bin/yum info, NOPASSWD: /usr/sbin/aureport -a, PASSWD: /usr/bin/systemctl reboot

ray     rushmore = NOPASSWD: /bin/kill, PASSWD: /bin/ls, /usr/bin/lprm

# To allow all wheel group users to run all commands without password.
%wheel ALL=(ALL)       NOPASSWD: ALL

# To install vlock.
yum -y install kbd

# To lock current tty/pts.
vlock

# To lock all tty.
vlock -a


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

# To install xfs_admin.
yum -y install xfsprogs

# To install xfs_fsr.
yum -y install xfsprogs

# To install xfs_growfs
yum -y install xfsprogs

# Package for xfs_repair is "xfsprogs".

# To install xz.
yum -y install xz

# To install yum.
yum -y install yum

# To search for a package.
yum search STRING

# To look into packages list.
# Use of wildcards are optional.
yum list *STRING*

# To update system.
yum update

# To security update only.
yum -y update --security

# To check which package proides this command.
yum provides COMMAND

# To complete remove a package.
yum erase PACKAGE

# To clean yum all cache.
yum clean all

# To download package only.
yum download STRING

# To look for a package info .
yum info <package>

# To look for a group.
yum group list

# To install a group.
yum group install "GROUP NAME"

# To check history that what installed.
yum history

# To install zip.
yum -y install zip
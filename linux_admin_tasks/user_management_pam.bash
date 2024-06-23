# Useful commands -- useradd, usermod, groupadd, groupmod, groupdel, authconfig, passwd, chage, visudo, su, sudo, userdel, groupdel.
# Useful configuration files -- /etc/login.defs, /etc/default/useradd, /etc/shells, /etc/pam.d/su, /etc/sudoers /etc/skel /etc/passwd /etc/shadow /etc/group .

# Users in the "wheel" group can do all the adminitrative tasks by using the "sudo" command.
# Users in the "adm" group can read the system logs.


# Add ".hushlogin" file in a user's home directory to remove all the banners while logging in.
# A new banner can be added in the /etc/motd file.
# A hidden file can be added in the /etc/skel directory to use as the default files present in a new user account.

# To display about the shadow information.
getent shadow <user>
getent shadow | grep <user>

# To display the passwd information.
getent passwd <user>
getent passwd | grep <user>



# To add a group.
groupadd GROUP_NAME

# To add a group with GID.
groupadd -g GID GROUP_NAME


# To delete a group.
groupdel GROUP_NAME# To install groupmod.
yum -y install shadow-utils

# To change a group name.
groupmod -n NEW_GROUP_NAME OLD_GROUP_NAME

# To change a group GID.
groupmod -g GID GROUP_NAME

useradd -D # Shows the default new user configuration

# To create a new user.
useradd <username>

# UID, GID 100 - 999 are reserved for administartors.
# -c COMMENT, -g GID,-m creates home directory, -r creates system user, -s login sheel, -u UID
useradd -c Administrator -m -r -s /bin/bash -u 201 pranshu -k /etc/skel

# add user with a expiry date.
useradd -e YYYY-MM-DD <username>

# -g primary group -G supplementry group -u UID 
useradd -g oinstall -G dba -u 2000 <username>

# To delete a user recursively with its home directory.
userdel -r <username>

# To change a users login name.
usermod -l <old_name> <new_name>

# To change a users shell.
usermod -s /bin/bash <username>

# To change a users description or full name.
usermod -c "Pranshu Paul" paul
usermod -c '<description>' '<username>'

# To remove the full name.
usermod -c "" paul

# To change a users group.
# This removes the user from its current group.
usermod -g <groupname> <username>

# To add a user into a group with overriding previous.
usermod -aG <groupname> <username>

# To remove a user from a group
gpasswd -d <user> <group>
gpasswd -d paul wheel

# Locks out the user.
usermod -L <username>

# Unlocks the user.
usermod -U <username>

# To set expiry date of a user account.
usermod --expiredate YYYY-MM-DD <username>

# To add a user into the "wheel" group.
usermod -aG wheel <username>

# To add a user in the "adm" group to use the "journalctl" command.
usermod -aG adm <username>



# Locks the user passwor. The user still be able to access through SSH!
passwd -l <username>

# Unlocks the user password.
passwd -u <username>

# Deletes the user password.
passwd -d <username>

# Force expire a user password.
passwd -e <username>

echo $RANDOM $RANDOM | sha512sum | head -c 16 | passwd --stdin <user_name>

# Shows last logins.
last

# Shows last reboot
last reboot

# SHows only five reboot?
last reboot -n 5

# Shows for a specific user.
last pranshu

# Shows last failed logins.
lastb

# Shows for a specific user.
lastb paul

# Changes shell of the user.
chsh <username> 
chsh -s $(which bash) paul

# To install chage.
yum -y install shadow-utils

# To list a users details.
chage -l <username>

# To set a users password min and max expiry date.
# -m min days, -M max days.
chage -m 90 -M 100 <username>

# To set account expiry date.
chage -E 1-JAN-2022 <username>

# To change the full name of the user.
chfn

# To delete a specific entry
chfn <user> -o ""
chfn <user> -p ""

# To change passwords of multiple users.

cat > passwords << EOF
paul:Mysql#459
pranshu:Mysql#459
EOF

chpasswd -c SHA512 < passwords
 
# Roles

# To run command as second user.
su - USER -c '<command>'
su - paul -c 'ls -la'

# To install vlock.
yum -y install kbd

# To lock current tty/pts.
vlock

# To lock all tty.
vlock -a

##############################################################################
# Sudoers file configuration.
# ALWAYS EDIT THE SUDOERS FILE CAREFULLY.
# Use "vim' not "vi" because it highlights the syntax.

export EDITOR=$(which vim)
# If editing the "/etc/sudoers" file directly.
# Use the below command to check whether the syntax is correct or not.
# ALWAYS USE THE BELOW COMMAND FIRST TO VERIFY THE SYNTAX IN THE SUDOERS FILE.
visudo -c
visudo -c -f <path_to_the_sudoers_file>

# Format
# user machine.ip=(as_which_users) [NOPASSWD:]commands
# who where = (as_whom) what
# % - indicates group names.

This is the directory "/etc/sudoers.d" where custom files can be added.
Always add custom configurations in the directory "/etc/sudoers.d"

# %group host=(users) [NOPASSWD:]commands
%pranshu ALL=(ALL) NOPASSWD: /usr/bin/yum, NOPASSWD: /usr/sbin/aureport, PASSWD: /usr/bin/systemctl

# Instead of giving the complete access to the commands, only few options can also be provided.
%pranshu ALL=(ALL) NOPASSWD: /usr/bin/yum info, NOPASSWD: /usr/sbin/aureport -a, PASSWD: /usr/bin/systemctl reboot

# USER MACHINE NOPASSWORD COMMANDS.
oracle ALL = NOPASSWD: /bin/systemctl start, /bin/systemctl restart vncserver

# To allow all the wheel group users to run all commands without password.
%wheel ALL=(ALL)       NOPASSWD: ALL

# For a single user.
<username> ALL=(ALL) NOPASSWD:ALL

# To avoid the allocation of tty.
echo 'Defaults use_pty' >> /etc/sudoers.d/custom

# To make sure that default credential caching time is 15 minutes.
echo 'Defaults env_reset, timestamp_timeout=15' >> /etc/sudoers.d/custom/etc/sudoers.d/custom

# Avoid use of NOPASSWD for privilege escalation.

############################
# SAMPLE CONFIGURATION FILES

# To edit the /etc/passwd file.
vipw

# To edit the /etc/shadow file.
vipw -s

# To edit the /etc/group file
vigr

# To edit the /etc/gshaddow
vigr -s

username:password:UID:GID:comment:home-directory:login-shell

x -- means password is encrypted

root:x:0:0:root:/root:/bin/bash


#############
# /etc/shadow

# To edit the /etc/shadow file.
vipw -s

# username:$6$hashedpassword:lastchg:minage:maxage:warn:inactive:expire:flag

# root:$6$jKZME4R4$NnQ4lmr/7f26AzYmCeaVEamV05Ri2le3HObxcYCVHSjRsg4yBM3eyJcaU/et9pFzT7.lQmXIBxJ790LKA.OiB.:18889:0:99999:7:::

# password -- $6$ = method of encryption = sha512sum after that is password hash



##############################################
# To install pwmake.
yum -y install libpwquality

# To generate a password.
pwmake 64

# To change a users password with prompted.
pwmake 64 | passwd --stdin <user_name>

# Disable the root account.
# Do not give any user the wheel group membership.
# Deny the users to use sudo -i or sudo -s who have been given sudo privileges.
# Override the wheel group behaviour why creating the file in /etc/sudoers.d
pranshu  ALL=(ALL) NOEXEC: /bin/sudo -i, /bin/sudo -s, NOPASSWD: ALL
%wheel  ALL=(ALL) NOEXEC: /bin/sudo -i, /bin/sudo -s, NOPASSWD: ALL

# Allow only the wheel group or a specifc group to use the su command.
auth            requisite       pam_wheel.so use_uid group=<group_name>

# Change the root user shell.
chsh -s /sbin/nologin root
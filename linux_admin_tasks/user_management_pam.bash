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
useradd -c Administrator -m -r -s /bin/bash -u 201 pranshu

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

echo $RANDOM $RANDOM | sha512sum | head -c 16 | passwd --stdin <user_name>

# Shows last logins.
last

# Shows last failed logins.
lastb



# Changes shell of the user.
chsh <username> 

# To install chage.
yum -y install shadow-utils

# To list a users details.
chage -l <username>

# To set a users password min and max expiry date.
# -m min days, -M max days.
chage -m 90 -M 100 <username>

# To set account expiry date.
chage -E 1-JAN-2022 <username>

chgrp <group> <file>


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

# -v verbose can be used to to make logs.
# To change a file's owner.
chown <user> <file>

# To change a file's owner and group:
chown <user>:<group> <file>

# To change a directory's owner recursively:
chown -R <user> <directory>

# To change ownership to match another file:
chown --reference=<reference_file> <file>


# setfacl
setfacl --modify user:<user>:<perms> <file>
setfacl --modify user:opc:rw test

# Removing all ACLs.
setfacl -b <file>



# To run command as second user.
su - USER -c '<command>'
su - paul -c 'ls -la'

# To install vlock.
yum -y install kbd

# To lock current tty/pts.
vlock

# To lock all tty.
vlock -a


############################################################################
# module-type control-flag module-path [module-options]

# module-type: auth, account, password, and session

# auth: Performs user authentication tasks, such as checking passwords, biometric data, or hardware tokens.
# account: Performs checks on the user's account status, such as account expiration, access time restrictions, and account lockout.
# password: Enforces password policies, enforces password change intervals, and validates new passwords.
# session: Sets up and manages user sessions, handles session-related tasks like creating directories, mounting filesystems, and setting environment variables.

# control-flag: required, requisite, sufficient, and optional

# required: If this module fails, authentication fails immediately.
# requisite: If this module fails, no further authentication is performed.
# sufficient: If this module succeeds, no further authentication is performed.
# optional: The success or failure of this module doesn't affect the overall authentication result.






# Add the following line or uncomment in the file "/etc/pam.d/su" to avoid the users using the "su" command who are not in the "wheel" group.
auth            requisite       pam_wheel.so use_uid


faillock --user USERNAME --reset
##############################################################################
# Sudoers file configuration.
# ALWAYS EDIT THE SUDOERS FILE CAREFULLY.
# Use "vim' not "vi" because it highlights the syntax.

export EDITOR=vim
# If editing the "/etc/sudoers" file directly.
# Use the below command to check whether the syntax is correct or not.
# ALWAYS USE THE BELOW COMMAND FIRST TO VERIFY THE SYNTAX IN THE SUDOERS FILE.
visudo -c
visudo -c -f <path_to_the_sudoers_file>

# Format
# user machine.ip=(from_which_users) [NOPASSWD:]commands
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




############################
# SAMPLE CONFIGURATION FILES

# To edit the /etc/passwd file.
vipw


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
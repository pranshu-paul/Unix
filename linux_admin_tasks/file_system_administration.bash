# File system administration

# Print the current working directory.

# Long listing of the current directory.
ls -l

ls -ltr --time-style=full-iso

# US style
export TIME_STYLE='+%b %d, %Y %H:%M:%S'
ls -ltr --time-style='+%b %d, %Y %H:%M:%S'

# Indian style
export TIME_STYLE='+%d-%b-%Y %H:%M:%S'
ls -ltr --time-style='+%d-%b-%Y %H:%M:%S'

# Dereference the symbolic link and prints the physical path.
ls -lL

# Prints files followed by their type.
# / -- for a directory; * -- for an executable.; @ -- for a symbolic link.
ls -F

# Lists hidden files and directories only.
ls .[^.]*

# To list only the contents of a directory.
ls -A
ls -d * .[^.]* # Same as above.

# Prints the physical directory.
pwd -P

# Deleting the hidden files while preserving the current and the parent directory.
rm -rfv --no-preserve-root lg/.*


# To take backup of a file.
cp -v /etc/hosts{,.bak}

# To copy the directory without copying itself.
cp  --recursive --no-target-directory --verbose /etc/skel lg/
cp  -rvT /etc/skel lg/

# To change a file's extension.
mv -v test{.txt,.sh}

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
chmod 0755 myscript.sh

# Remove read/write/execute from (myscript.sh), symbolic mode.
chmod = myscript.sh

# Set user to read/write/execute, and group and others to read only permission to (myscript.sh), symbolic mode.

chmod u=rwx, go=r myscript.sh


# To preserve the user's ownership of an executable, use SUID.
chmod -v 4755 <file>

# 'S' means the file is not an executable 'x'
# To set read-only permissions and make the file immutable.
chmod -v 4644 <file>

# To inherit the goup's membership for the newly files created in a directory, use SGID.
chmod -v 2775 <directory>

# To inherit the group membership and prevent the grop members from deleting the files they don't own inside the directory.
chmod -v 3775 <directory>

# To prevent a file deletion from other users use, sticky bit.
# Upper case T means that the file is not an executable.
chmod -v 1666 <file>

# To prevent a directory deletion from other users use sticky bit directory under the /.
chmod -v 1755 <directory/executable_file>


# Package = coreutils
chown - change file owner and group

# -v verbose can be used to to make logs.
# To change a file's owner.
chown <user> <file>

# To change a file's owner and group:
chown <user>:<group> <file>

sudo chown $(id -u):$(id -g) <file>

# To change a directory's owner recursively:
chown -R <user> <directory>

# To change ownership to match another file:
chown --reference=<reference_file> <file>

# To change the group of a file or directory.
chgrp <group> <file/directory>


# setfacl
# ACL must be enabled for the file system in the mounting options (/etc/fstab or mount).
# X: means a conditional executable permission.
setfacl --modify user:<user>:<perms> <file>
setfacl --modify user:opc:rw test

# Print the ACL on a file or directory.
getfacl -p <file>

# Removing all ACLs.
setfacl -b <file>

# Remove ACL of a file for a user.
setfacl -x u:<user> <file>

# Grant permissions to multiple users and groups. Beyond the file owner and the file's group.
# These affilations are called named users and named groups.

# Display a file ACL settings.
getfacl <file/directory>

# Mask entry sets the maximum possible permissions for all the named users, and groups.

# To save a directory ACL recursively into a file.
getfacl -R /dir1 > file1

# The output can be used to create or transfer the ACLs to another directory.
setfacl --set-file=file1

# Allow the user to enter in the directory.
setfacl -m u:nitesh:r-X /app01/traces

# Create ACL for the user satish.pandey to read the future objects on the directory.
setfacl -m d:u:nitesh:r-X /app01/traces
setfacl -m d:g::--- /app01/traces
setfacl -m d:o::--- /app01/traces

# Set the default mask.
setfacl -m d:m:r-X /app01/traces

# Process user should be as a named user on the file to access the file.
# Process group should be as a named group on the file to access the file.

# The file system where the ACLs being appliead should not have noacl in the mount options
mount -o remount,acl /app01/traces

# To delete a default named user ACL
setfacl -x d:u:<user> <directory>

# To delete the all the default ACL entries on a directory.
setfacl -k <directory>

# Top 10 files sorted by size.
du -ah | sort -rh | head -n 10

# Prints size of the files greater than 100 MiB
find $PWD -size +100000000c -print

# List attributes of a directory and file.
lsattr

# Change attributes of a file or directory.
# Make the file appendable only.
chattr +a <file/directory>

# Make the file immutable.
chattr +i <file/directory>

# To truncae a file.
truncate --size 0 <file>

# Another example to truncate a file
find <path> -name reports.log -size +1610612736c -type f -ls -exec sh -c 'echo -n "" > "{}"' \;

# To create version controlled backups.
# Values available for the variable "VERSION_CONTROL".
# This variable also works with cp, mv as well.
# none, off       never make backups (even if --backup is given)
# numbered, t     make numbered backups
# existing, nil   numbered if numbered backups exist, simple otherwise
# simple, never   always make simple backups
export VERSION_CONTROL=numbered
install -b -v -D <file> <destination>

# To copy and change the ownership of a file or folder in a single command. (root only)
install -v -m 644 -o <user> -g <group> <file> <destination>

# To truncate a file and the file non-recoverable.
shred

# To mount in temporary file system in the virtual memory of a system.
mount -t tmpfs -o mode=755,size=128M tmpfs /mnt

# To avoid use of any special devices.
mount -o nodev /dev/sda1 /mnt

# To avoid any privilege escalation attack.
mount -o nosuid /dev/sda1 /mnt

# To avoid execution of any binary and shell scripts.
mount -o noexec /dev/sda1 /mnt

# To mount an iso.
mount -o ro,loop /dev/sr0 /mnt

# To mount for a specific UID and GID.
mount -o uid=<uid>,gid=<gid> path/to/device_file path/to/target_director

# To print the PIDs of the processes on the mount point when unable to unmount.
fuser -mu /mnt

# Kill the process with associated with the mount point.
fuser -ck /mnt

# To kill a user's temp session
fuser -ck /run/user/0

sudo umount  -fl /run/user/0

# To unmount a file system when not able to unmount or an NFS.
umount -l /mnt

# Hide the processes of the root user from the other users.
mount -o remount,rw,hidepid=2 /proc

# Add the below entry in the /etc/fstab file.
proc /proc proc defaults,noexec,hidepid=2 0 0
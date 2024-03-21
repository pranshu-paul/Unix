ls -ltr --time-style=full-iso

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


# To copy the directory without copying itself.
cp  --recursive --no-target-directory --verbose /etc/skel lg/
cp  -rvT /etc/skel lg/

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


# Top 10 files sorted by size.
du -ah | sort -rh | head -n 10

# Prints size of the files greater than 100 MiB
find $PWD -size +100000000c -print


lsattr

chattr


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
install -v -o <user> -g <group> <file> <destination>

shred
# To install file.
yum -y install file

# To get the MIME type.
file -i <file_name>/<directory_name>


# To get the information of user name and group.
stat --format="%U %G" <file_name>

# To get the birth date of a file.
stat --format="%w" /



# To install locate.
dnf -y install mlocate

# Update the DB of all the files on the system.
updatedb


# To locate a file or folder on the system.
locate <name>


# To execute a command on the output of a command.
ls . | xargs -i file {}

# To install find.
yum -y install findutils

# To find in current directory.
find . -name <name> -print

# To find from root node.
find / -name <name> -print

# To find a file not equal to the name.
find $PWD -maxdepth 1 ! -name <name> -print

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

# To delete a particular user owned files.
find . -user oracle -exec rm -fr {} \;
# To install tar.													
c -- create, v -- verbose, z -- gzip, f -- use archive file
yum -y install tar													
																	
																	

# To create a compressed tar.
tar cvzf TAR_NAME_.tar.gz FOLDER_NAME

# To extract tar.
tar xzvf TAR_NAME_.tar.gz

# To list content of a tar.
tar tvf TAR_NAME_.tar.gz

# To update a tar contents.

# First decompresses .gz
gunzip TAR_NAME_.tar.gz						


# Updating tar
tar uf TAR_NAME_.tar FILE_OR_FOLDER_NAME

# Again compressing
gzip TAR_NAME_.tar


# To delete contents from a compress.
gunzip TAR_NAME_.tar.gz
tar cvf TAR_NAME_.tar FILE_OR_FOLDER_NAME --remove-files
gzip TAR_NAME_.tar



BACKUP AND RESTORE ON RHEL OF XFS FILESYSTEM.

BACKUP:

Utility: xfsdump
Package: xfsdump.x86_64

xfsdump -l <level> [-L label] -f <backup-destination> <path-to-xfs-filesystem>

Standard Options for xfsdump:
-L option lets you choose by the session label
-l level
-R option lets you to continue backup in case of any interruption.

# Performing a full backup of a filesystem.
xfsdump -l 0 -L "backup_boot" -f /dev/st0 /boot

xfsdump -l 0 -L "Backup level 0 of /myxfs $(date)" -f /dev/st0 /myxfs


Incremental backup:
Level 1 backup records only file system changes since the level 0 backup.
Level 2 backup records only the changes since the latest level 1.
And so on up to level 9.

xfsdump -R -l 1 -L "Backup level 1 of /myxfs $(date)" -f /dev/st0 /myxfs


RESTORE:
Utility: xfsrestore
Package: xfsrestore.x86_64

The xfsrestore utility restores file systems from backups produced by xfsdump.

xfsrestore [-r] [-S session-id] [-L session-label] [-i] -f <backup-location> <restoration-path>

Standard Options for xfsrestore.
-L option lets you choose by the session label
-l level
-r incremental level restore from level 0 to 9
-i restores interactively.
-I displays information about the available backups, including the session ID and session label.
-S option lets you choose by the session ID

# Performing a full restore.
xfsrestore -L "backup_boot" -f /dev/st0 /mnt/boot/

USING XFSDUMP AND XFSRESTORE TOGETHER:
xfsdump -J - /myxfs | xfsrestore -J - /myxfsclone
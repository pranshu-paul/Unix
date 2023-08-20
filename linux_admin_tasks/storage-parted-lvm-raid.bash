# Storage Administration

# For the devices name starting with "sd"
dmesg | grep SCSI
journalctl -k | grep SCSI

# Lists the block drives with their file systems.
lsblk -f

# Create a GPT signature on the block drive.
parted /dev/sdb mklabel gpt

# Check the status of the block drive.
parted /dev/sdb print

# Create a partition.
parted /dev/sdb mkpart primary 0% 100%

# Assign a File System to the partition.
mkfs.xfs /dev/sdb1

# Check the File System.
parted /dev/sdb print

# Get the UUID of the block device.
blkid | grep /dev/sdb1 | awk '{print $2}'

# Mount the file system.
mount -t xfs UUID="3847161a-699b-4d0f-92c9-58d61c9c8344" /mnt

# Make an entry in "/etc/fstab"
# Use UUID insted of physcial path "/dev/sdx"
UUID="3847161a-699b-4d0f-92c9-58d61c9c8344" /mnt defaults 0 0

# Reload the system daemons after updating the "/etc/fstab"
systemctl daemon-Reload

# Verify the entry in "/etc/fstab"
mount -av

# To remove any FS signature.
wipefs -a /dev/sdb1
wipefs -a /dev/sdb


######################################################
# RAID stands for Redundant Array of Independent Disks.

# Check the block drives.
# mdadm stands for "Multiple Device Admin"
mdadm --examine /dev/sd[a-d]
mdadm --create /dev/md0 --level=stripe --raid-devices=2 /dev/sd[a-b]1

mdadm --create /dev/md0 --level=6 --raid-devices=4 /dev/sd[a-d]1

cat /proc/mdstat
lsblk

mdadm --examine /dev/sd[a-b]1
mdadm -E /dev/sd[a-b]1

mdadm --detail /dev/md0

mkfs.xfs /dev/md0
restorecon -Rv /mnt

mdadm -E -s -v >> /etc/mdadm.conf
mount /dev/md0 /mnt

vim /etc/fstab
/dev/md0        /mnt    xfs     defaults        0 0

umount /mnt
mount -av


# REMOVING A RAID
mdadm --stop /dev/md0

mdadm --zero-superblock /dev/sda1 /dev/sdb1

# To remove any filesystem and raid signatures.
# This command will remove all data also from the drive.
# First remove file system signature from the partitions.
# WARNING! THE BELOW COMMAND CAN WIPE ALL THE DATA ON A DRIVE SO, USE IT CAREFULLY.
wipefs -a /dev/sd[a-d]1

# Then remove the partitions.
wipefs -a /dev/sd[a-d]

cat /dev/null > /etc/mdadm.conf

# Refresh the kernel's partition table.
partprobe -s

# Create XFS file system
mkfs.xfs -f /dev/sda

# Mount all the entres in "/etc/fstab"
mount -av

# List all the partitions.
cat /proc/partitions


###########################
# Logical Volume Management

# Packages required.
yum -y install lvm2

# Create a basic parititon.
parted /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary 0% 100%
parted /dev/sdb set 1 lvm on

# Brief display for physical volumes.
pvs

# To display physical volumes.
pvdisplay

# To create a physical volume.
pvcreate /dev/<block_device> /dev/<block_device> ...

# To remove a physical volume.
pvremove /dev/<block_device> /dev/<block_device> ...

# Brief display for volume groups.
vgs

# To create a volume group.
vgcreate <volume_group_name> /dev/<physical_volume_created>

# To extend a volume group.
vgextend <volume_group_name> /dev/<new_physical_volume_created>

# To remove a physical volume from a volume group.
vgreduce <volume_group_name> /dev/<physical_volume_which_want_to_remove>

# To remove a volume group.
vgremove <volume_group_name>

# Brief display for logical volume.
lvs

#  To create a logical volume. [-L|--size] [-n|--name]
lvcreate --size 5G --name <any_name> <vg_group_name>

# To display logical volumes.
lvdisplay

# To extend a logical volume. [-L|--size]
lvextend --size +1G /dev/<vg_group_name>/<logical_volume>

# To resize a logical volume. [-L|--size]
# Resize the file system first (xfs_growfs)
lvresize --size -1G /dev/<vg_group_name>/<logical_volume>

# To remove a logical volume.
# First unmount the file system.
lvremove /dev/<vg_group_name>/<logical_volume>

# To rename a logical volume.
lvrename /dev/<vg_group_name>/<logical_volume_old_name> /dev/<vg_group_name/<logical_volume_new_name>

# To get UUID.
blkid


###########################
# Creating a SWAP partition.
# Check the status of the block drive.
parted /dev/sdc print

# Create a partition.
parted /dev/sdc mkpart primary 0% 100%

# Create the SWAP file system.
mkswap /dev/sdc1

# Update the kernel's partition table.
partprobe -s

# Get the Block ID.
blkid | grep /dev/sdc1 | awk '{print $2}'

# Sample for SWAP partitons "/etc/fstab".
UUID="c6cbbcf6-5262-4b8c-913b-638919fcbd9f" none swap defaults 0 0

# After making any changes in "/etc/fstab"
systemctl daemon-reload 

# Verify the SWAP partition.
swapon -s


# To remove a SWAP partition.
swapoff /dev/sdc1

# Wipe the File System and partition signatures.

######################################## Sample fstab file #############################################
/etc/fstab

[DEVICE_NAME]		 [MOUNT_POINT]		 [FILE_SYSTEM]		 [OPTIONS]		 [DUMP]		 [PASS]
UUID="<uuid>" 	 	 /mnt				 xfs		  		 defaults		     0		      0
UUID="<uuid>" 	 	 none 				 swap 		  		 defaults 		     0		      0

LABEL=<label_name> -- # When mounting using label.
UUID="<uuid>" -- # When mounting using UUID.


# After making any changes in "/etc/fstab"
systemctl daemon-reload


##################################
# Creating partitions from "fdisk".
# The below command is creating a GPT partition with complete size and saving it.
printf "g\nn\n1\n\n\nw\n" | fdisk /dev/sdc


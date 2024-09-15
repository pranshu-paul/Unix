 # Storage Administration

# Synchronizes all pending I/O operations.
sync

# To trim a solid state drive.
fstrim /

# Prints how much data is in the cache
# Commit the data using sync and verify again 
cat /proc/meminfo | grep -E 'Dirty|Writeback'

# Clears page cache (contiguous block of memory)
echo 1 > /proc/sys/vm/drop_caches

# Clears directory entries and index nodes.
echo 2 > /proc/sys/vm/drop_caches

# Clear the all caches.
echo 3 > /proc/sys/vm/drop_caches   # Clear all caches

# /sys direcctory contains the "view" of physical drives.

# To view the major and minor number
stat -c '%n %t:%T' /dev/sda1 /dev/sda2 /dev/sda3

# For the devices name starting with "sd"
dmesg | grep -e SCSI | grep sd
journalctl -k | grep SCSI | grep sd

# To split a volume group and create a new volume group from the underlying physical volume
# This will a volume group and keep the extent size to new volume group
vgsplit vg01 vg02 /dev/sdc1

# To create a cole of OS
# Copy the OS disk
dd if=/dev/sda of=/dev/sde bs=32M conv=noerror,sync status=progress

# COpy the swap disk or other disk
dd if=/dev/sdc of=/dev/sdf bs=32M conv=noerror,sync status=progress

###########################################################################################
# To extend too partition on LVM
# Add storage
# Create a parition
fdisk /dev/sda

partprobe -s

pvcreate /dev/sda4

vgextend <existing_volume_group>

lvextend --size +5G <root_volume_group>

xfs_growfs /

###########################################################################################


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
systemctl daemon-reload

# Verify the entry in "/etc/fstab"
mount -av

# The Systemd approach to mount a file systemd over the /etc/fstab file.

# Create a "mnt.mount" unit file in the /etc/systemd/system directory.
# "<name>.mount" name must be equal to "Where" of the unit file.

systemctl edit mnt.mount --full --force
env EDITOR=vim systemctl edit mnt.mount --full --force

# Or

cat << EOF > /etc/systemd/system/mnt.mount
[Unit]
Description=Mounts sdb1

[Mount]
What=/dev/sdb1
Where=/mnt
Type=xfs
Options=defaults
EOF


# Create a unit file to automount the filesystem.
cat << EOF > /etc/systemd/system/mnt.automount
[Unit]
Description=Automounts sdb1

[Automount]
Where=/mnt
TimeoutIdleSec=10min

[Install]
WantedBy=multi-user.target
EOF

# Refresh the unit files.
systemctl daemon-reload

# To mount the device.
systemctl start mnt.mount

# To unmount the device.
systemctl stop mnt.mount

# To permanently enable the device at every boot.
systemctl enable --now mnt.automount

# To remove any FS signature.

# First remove the parititon then the device itself.
wipefs -a /dev/sdb1
wipefs -a /dev/sdb

# To list inodes tree
tree --inodes -L 2

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
wipefs -a /dev/sd[b-d]1

# Then remove the partitions.
wipefs -a /dev/sd[b-d]

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
lvextend --size +900M /dev/vg-00/my_vol
lvresize --resizefs --size +15GB /dev/VG00/var

# Extend the existing XFS file system.
xfs_growfs /mnt

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

# To increate the swap size
lvextend --size +12G  /dev/ol_oel8/swap

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
UUID="304786a6-f5b5-4067-b009-e3304d792b8c" none swap defaults 0 0
UUID="304786a6-f5b5-4067-b009-e3304d792b8c" none swap pri=4  0 0
UUID="304786a6-f5b5-4067-b009-e3304d792b8c" none swap pri=10  0 0

# After making any changes in "/etc/fstab"
systemctl daemon-reload 

# Verify the SWAP partition.
swapon /dev/vg00/swap

swapon -sv
swapon --show

# To remove a SWAP partition.
swapoff /dev/sdc1

# Wipe the File System and partition signatures.


# To change the priority of a swap partition.
swapoff /dev/vg00/swap01

wipefs -a /dev/vg00/swap01

mkswap /dev/vg00/swap01

swapon -vp -4 /dev/vg00/swap01

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


##################################
# Script to create a raid
for char in {b..g}; do
	parted /dev/sd${char} mklabel gpt
	parted /dev/sd${char} mkpart primary 0% 99%
	parted /dev/sd${char} set 1 raid on
	parted /dev/sd${char} print
done


mdadm --examine /dev/sd[b-g]1

mdadm --create /dev/md0 --level=6 --raid-devices=6 /dev/sd[b-g]1

mdadm --examine /dev/sd[b-g]1

for char in {b..g}; do
	blkid | grep /dev/sd${char}1 | awk '{print $2}'
done

mdadm --detail /dev/md0

mkfs.xfs /dev/md0

mdadm -E -s -v >> /etc/mdadm.conf

lsblk  -f /dev/sd[b-g]1

partprobe -s

echo "$(blkid /dev/md0 | awk '{print $2}') /mnt xfs defaults 0 0" >> /etc/fstab

restorecon -Rv /mnt

mount -av


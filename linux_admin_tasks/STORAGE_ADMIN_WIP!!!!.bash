# Creating a Stratis pool

dnf -y install stratisd stratis-cli

systemctl enable --now stratisd

lsblk

# To confirm that /dev/sde don't have a partition table
blkid -p /dev/sde

# Clear the partition table if exists.
wipefs -a /dev/sde


# To create a pool
stratis pool create mypool /dev/sde

# Confirm the pool
stratis pool list

# Create filesystem from a Pool.
stratis fs create mypool filesystem

stratis ls

lsblk

mkdir /stratis

blkid -p /dev/stratis/mypool/filesystem

echo "UUID=<uuid> /stratis xfs defaults 0 0" | tee -a /etc/fstab

systemctl daemon-reload

mount -av


##
mdadm -C /dev/md0 --level=raid1 /dev/sda1 /dev/sdb1

mdadm --detail



##
e2fsck -c /dev/sda

##
# To add the usrquota and grpquota

edquota

repquota

/dev/sda1  /home  ext4  defaults,usrquota,grpquota  0  0

mount -o remount /home

quotacheck -cug /home

quotaon

groupquota

quotaoff


# To set a soft disk quota limit
edquota -s

lvm list

vgdisplay --verbose

lvdisplay --verbose

xfs_repair -f /dev/sda

# To set a spicifc inode quota for a user.
edquota -i

# To set a hard disk quota limit for a user
edquota -h

e2fsck -f /dev/sda

# In the emergency mode!
fsck -f /


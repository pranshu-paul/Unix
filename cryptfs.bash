# Encrypting storage devices

# Install the cryptsetup utility
yum -y install cryptsetup-luks

# Encrypt and format the drive.
cryptsetup -y -v luksFormat <device_name>

# Open the drive
cryptsetup luksOpen <device_name>

# Get the header information of the drive.
cryptsetup luksDump <device_name>

# Clear the device
dd if=/dev/zero of=/dev/mapper/<logical_device> bs=128

# Create a filesystem on the drive or partition
mkfs.ext4 /dev/mapper/<logical_device>

# Mount the device.
mount /dev/mapper/<logical_device> /mnt

# Unmount and lock the device.
cryptsetup luksClose <device_name>
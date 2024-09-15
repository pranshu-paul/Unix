# Patching the kernel

# Print the default kernel
grubby --default-kernel

# Version of the newer Oracle Unbreakable Enterprise Kernel.
VERSION='5.15.0-207.156.6'

# Create a directory to download the kernel packages.
mkdir -p "/tmp/kernel-${VERSION}"

# Download the required kernel packages
wget "https://yum.oracle.com/repo/OracleLinux/OL8/UEKR7/x86_64/getPackage/kernel-uek-${VERSION}.el8uek.x86_64.rpm "
wget "https://yum.oracle.com/repo/OracleLinux/OL8/UEKR7/x86_64/getPackage/kernel-uek-core-${VERSION}.el8uek.x86_64.rpm"
wget "https://yum.oracle.com/repo/OracleLinux/OL8/UEKR7/x86_64/getPackage/kernel-uek-modules-${VERSION}.el8uek.x86_64.rpm"

# Install the packages.
dnf localinstall "kernel-uek-${VERSION}.el8uek.x86_64.rpm" "kernel-uek-core-${VERSION}.el8uek.x86_64.rpm" "kernel-uek-modules-${VERSION}.el8uek.x86_64.rpm"

# Update the default kernel
grubby --set-default "/boot/vmlinuz-${VERSION}.el8uek.x86_64 "

# Update the boot loader
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

# Reboot the server
systemctl reboot

# Verify the new kernel
uname -r

# Review the changes introduced in the release
https://docs.oracle.com/en/operating-systems/uek/7/relnotes7.2/UEK-RELNOTES-7-2.pdf

# Review the changes
rpm -q --changelog kernel-uek-5.15.0-207.156.6.el8uek.x86_64

rpm -q --changelog kernel-uek-5.15.0-207.156.6.el8uek.x86_64 | grep CVE-


# Other packages to take in account while patching
# Web Server: Nginx
# OS System library: Glibc
# SSH Server: OpenSSH
# Cryptographic Library and package: OpenSSL

# Verify the current versions
nginx -v
mysql --version
rpm -q glibc
ssh -V
openssl version

# ===== Rollback Plan ===== #

# Reset to the previous kernel
grubby --set-default vmlinuz-5.15.0-204.147.6.2.el8uek.x86_64

# List the new kernel installed.
dnf list installed "kernel-uek-${VERSION}.el8uek.x86_64" "kernel-uek-core-${VERSION}.el8uek.x86_64" "kernel-uek-modules-${VERSION}.el8uek.x86_64"

# List the history of transaction ids.
dnf history info
dnf history list kernel-uek kernel-uek-core kernel-uek-modules

# Remove the packages gracefully
dnf history undo <id>



####
dnf updateinfo summary

# Download the below mentioned packages to update the kernel
kernel             
kernel-core        
kernel-modules     
kernel-modules-core

dnf -y install leapp leapp-repository


leapp preupgrade

leapp upgrade
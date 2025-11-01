# Live Patching rhel 

dnf install kpatch

# Start and enable the kpatch service
systemctl enable --now kpatch.service



# Update the kernel and its dependencies
dnf update kernel


# Install the kpatch kernel module
dnf install kpatch-patch-5_14_0-427_13_1.x86_64

# Verify the update the patch
kpatch list


# Verify the version.
cat /etc/system-release


# Linux patching CVE common vulnerabilities and exposures

# Prevents from cyber attacks and emerging threats
# Fixes mistakes in the system code
# Adds new features and introduces more security
# Improves performance and resource utilization

# Ensure backups are taken, and downtime is required

# Verify the updated kernel or package with the Application and DB team

# Perform a reboot before patching to ensure that the services are running properly before making any changes

# Verify the current state of the machine; pre and post patching

# Uptime
# Mount points
# Block IDs and
# Kernel routing table
# File system Table
# Block device information
# Volume groups
# Logical volumes
# Memory snapshot
# Grub information
# Processes information
# Monitor the VM performance

# Requirements
A VM with internet enabled and access to Oracle Repos to get the details about the Common Vulnerabilities and Exposures


# Patching the system #

# To list the CVEs
dnf updateinfo info --sec-severity=Critical
dnf updateinfo info --sec-severity=Important

# Check the packages available for the CVEs
dnf check-update --cve CVE-2024-31080
dnf check-update --cves CVE-2024-2961,CVE-2024-1086
dnf check-update --cves CVE-2023-40546,CVE-2024-3019

# To review the bug changelogs with the Application Team
dnf check-update --cve CVE-2019-11043 --changelogs

# Download the packages for the CVEs

# To mitigate CVEs
dnf update --cve CVE-2024-3019
dnf update --cve CVE-2024-2961,CVE-2024-1086 --comment=<add_a_comment_about_the_change>

# Check which packages require reboot
# Install yum-utils
needs-restarting -r

# Verify the previous updated packages
dnf history

# To rollback any changes
dnf history info 19

dnf history undo 19

# Or, downgrade a package
dnf downgrade <package_name>
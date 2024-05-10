# Pluggable Authentication Modules

# module-type control-flag module-path [module-options]

# module-type: auth, account, password, and session

# auth: Performs user authentication tasks, such as checking passwords, biometric data, or hardware tokens.
# account: Performs checks on the user's account status, such as account expiration, access time restrictions, and account lockout.
# password: Enforces password policies, enforces password change intervals, and validates new passwords.
# session: Sets up and manages user sessions, handles session-related tasks like creating directories, mounting filesystems, and setting environment variables.

# control-flag: required, requisite, sufficient, and optional

# required: If this module fails, authentication fails immediately.
# requisite: If this module fails, no further authentication is performed.
# sufficient: If this module succeeds, no further authentication is performed.
# optional: The success or failure of this module doesn't affect the overall authentication result.

# The below directory contains the available pam modules.
ls /usr/lib64/security

# Add the following line or uncomment in the file "/etc/pam.d/su" to avoid the users using the "su" command who are not in the "wheel" group.
# Also a group can be added to allow the "su" command
auth            requisite       pam_wheel.so use_uid group=<group_name>

# Check the configuration syntax.
authselect check

# To enforce password quality.

# To list the current profile with enabled and siabled features. 
authselect current

# Select a profile. sssd (System Security Services Daemon)
authselect select sssd

# To enforce password quality.
cat > /etc/security/pwquality.conf.d/pwquality.conf << EOF
enforce_for_root
minlen = 9
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
dictcheck = 1
usercheck = 1
retry = 3
EOF

# To enable password history check.
authselect select sssd with-pwhistory

cat > /etc/security/pwhistory.conf << EOF
enforce_for_root
use_authtok
remember = 10
retry = 3
EOF

# To disable authentication with an empty passwords
authselect enable-feature without-nullok

## Enabling pam_faillock to prevent brute force attacks.
# For more details: man 5 faillock.conf
authselect select sssd with-faillock

cat > /etc/security/faillock.conf << EOF
deny=3
unlock_time=600
silent
even_deny_root
EOF

# To check which users are locked.
faillock

# To unlock a user.
faillock --user <username> --reset

# Take a backup of the current profile.
authselect apply-changes -b --backup=profile.backup

# List the old backups.
authselect backup-list

# Restore from the backed up profile.
authselect backup-restore profile.backup

# To create a custom profile from the backup of sssd.
authselect create-profile neo-profile -b sssd --symlink-meta --symlink-pam

# Implement the custom pam configs forcefully.
authselect select custom/neo-profile --force

# Apply the changes after making any changes in the custom profile.
authselect apply-changes
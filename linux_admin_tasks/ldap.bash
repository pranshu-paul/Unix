# Configuring LDAP server.

# Packages required for LDAP.
packages=(
cracklib
cyrus-sasl-lib
glibc
gcc
gcc-c++
elfutils-libelf-devel
kernel-headers
glibc-headers
libdb
libdb-utils
libtool-ltdl
libxcrypt
openssl-libs
perl-libs
cyrus-sasl-devel
libtool-ltdl-devel
libdb-devel libtool
autoconf perl
perl-devel
)

# Install development tools.
dnf groupinstall "Development Tools" -y

# Create a user account.
useradd -r -M -d /var/lib/openldap -u 55 -s /usr/sbin/nologin ldap

# Download LDAP.
version=2.6.6
wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-"${version}".tgz

# Extract LDAP.
tar -xvzf openldap-"${version}".tgz

# Move LDAP to /opt
mv openldap-"${version}" /opt

# Run configure.
./configure

# Build the software.
make depend
make

# Install LDAP.
make install

# Change the permissions and ownership of the directories.
chown -R ldap:ldap /var/lib/openldap
chown root:ldap /etc/openldap/slapd.conf
chmod 640 /etc/openldap/slapd.conf


# Verify the 
ls -l /etc/openldap/slapd.ldif

# Just change the below line only in file "/usr/local/etc/openldap/slapd.ldif"
# At line no. 82 and 83.
olcSuffix: dc=paulpranshu,dc=xyz
olcRootDN: cn=Manager,dc=paulpranshu,dc=xyz

# Create "olcDbDirectory" directory.
mkdir -p /usr/local/var/openldap-data

# Remove the previous "ldif" file.
cd /usr/local/etc/slapd.d
rm -rfv *

# Add the LDAP configuration file to its location/
slapadd -n 0 -F /usr/local/etc/slapd.d -l /etc/openldap/slapd.ldif

# Start LDAP with the directory of "ldif" file.
/usr/local/libexec/slapd -F /usr/local/etc/slapd.d

# Verify LDAP daemon.
ps -ef | grep slapd
ss -lt | grep ldap


# Verify LDAP.
ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts

# Create a systemd unit file for LDAP.
vim /etc/systemd/system/slapd.service
[Unit]
Description=OpenLDAP Server Daemon
After=syslog.target network-online.target
Documentation=man:slapd
Documentation=man:slapd-mdb

[Service]
Type=forking
Environment="SLAPD_URLS=ldap:/// ldapi:/// ldaps:///"
Environment="SLAPD_OPTIONS=/usr/local/etc/slapd.d"
ExecStart=/usr/local/libexec/slapd -F $SLAPD_OPTIONS

[Install]
WantedBy=multi-user.target

# Reload all the systemd unit-files.
systemctl daemon-reload
systemctl enable --now slapd

# Glossary #
cn = common name
dn = distinguished name
olc = OpenLDAP Configuration
# Packages required for LDAP.
packages=(\
cracklib \
cyrus-sasl-lib \
glibc \
gcc \
gcc-c++ \
elfutils-libelf-devel \
kernel-headers \
glibc-headers \
libdb \
libdb-utils \
libtool-ltdl \
libxcrypt \
openssl-libs \
perl-libs \
cyrus-sasl-devel \
libtool-ltdl-devel \
libdb-devel libtool \
autoconf perl \
perl-devel)

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


mkdir /var/lib/openldap /etc/openldap/slapd.d



chown -R ldap:ldap /var/lib/openldap
chown root:ldap /etc/openldap/slapd.conf
chmod 640 /etc/openldap/slapd.conf

rpm -ql sudo |  grep -i schema.openldap

# Copy the schema directory 
cp /usr/share/doc/sudo/schema.OpenLDAP  /etc/openldap/schema/sudo.schema

# Verify the 
ls -l /etc/openldap/slapd.ldif

vim /etc/openldap/slapd.ldif
dn: olcDatabase=mdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: mdb
OlcDbMaxSize: 1073741824
olcSuffix: dc=paul,dc=xyz
olcRootDN: cn=Manager,dc=paulpranshu,dc=xyz
olcRootPW: secret
olcDbDirectory: /usr/local/var/openldap-data
olcDbIndex: objectClass eq

mkdir -p /usr/local/var/openldap-data

cd /usr/local/etc/slapd.d
rm -rfv *

slapadd -n 0 -F /etc/slapd.d -l /etc/openldap/slapd.ldif

# Start LDAP and verify.
/usr/local/libexec/slapd -F /usr/local/etc/slapd.d

ps -ef | grep slapd

ss -lt | grep ldap


# Verify LDAP.
ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts
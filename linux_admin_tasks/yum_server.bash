#!/bin/bash

# Set a variable of the ISO path.
iso_path=/<path>

# Set a variable for the mount point of the ISO.
iso_mount_point=/<path>

# Create a mount point for the ISO.
mkdir -p "${iso_mount_point}"

# Mount the ISO to the previously created mount point.
mount -o loop "${iso_path}" "${iso_mount_point}"

# Change the following content in the file to avoid warnings in RHEL.
# Change enabled=1 to enable=0

# Set a variable for the path of the yum file.
subscription_configuration_path="/etc/yum/pluginconf.d/subscription-manager.conf"

if grep -q enabled=1 "${subscription_configuration_path}"; then
	sed -i "2s/enabled=1/enabled=0/" "${subscription_configuration_path}"
fi

# Create a variable for the repository.
repo_path=/<path>

# Create a directory for the repository.
mkdir -p "${repo_path}"

# Copy the directories containing packages into the previously created repository.
cp -r "${iso_mount_point}"/BaseOS "${iso_mount_point}"/Appstream "${repo_path}"

# Now, update the repo file.
cat > /etc/yum.repos.d/rhel.local.repo << EOF
[BaseOS.local]
name=BaseOS.local
baseurl=file://"${repo_path}"/BaseOS
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[Appstream.local]
name=Appstream.local
baseurl=file://"${repo_path}"/Appstream
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF

# Once the file is created, run the following command.
yum clean all


######################################################################################
Oracle Linux 9
  # curl https://yum.oracle.com/RPM-GPG-KEY-oracle-ol9 | gpg --import
Oracle Linux 8
  # curl https://yum.oracle.com/RPM-GPG-KEY-oracle-ol8 | gpg --import
Oracle Linux 7
  # curl https://yum.oracle.com/RPM-GPG-KEY-oracle-ol7 | gpg --import
  

######################################################################################
# Creating a yum server with apache web server on rhel 8.
dnf -y install httpd

mkdir /var/www/yumserver.rhel.com

chown -R apache:apache /var/www/*

if ! semanage fcontext -l | grep -o "yumserver.rhel.com" > /dev/null
then
	semanage fcontext -a -t httpd_sys_content_t "/srv/yumserver.rhel.com(/.*)?"
	restorecon -Rv /var/www/yumserver.rhel.com/
fi

mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bkp

echo "$(hostname -i)    yumserver.rhel.com" >> /etc/hosts

cat > /etc/httpd/conf.d/yumserver.rhel.com.conf << EOF
Listen 8080
<VirtualHost *:8080>
        
	DocumentRoot "/var/www/yumserver.rhel.com/"
        ServerName yumserver.rhel.com
        CustomLog /var/log/httpd/yumserver.rhel.com_access.log combined
        ErrorLog /var/log/httpd/yumserver.rhel.com_error.log

                <Directory "/var/www/yumserver.rhel.com">
                Options Indexes FollowSymLinks
                Allowoverride none
                Require all granted
        </Directory>

</VirtualHost>
EOF

# Run the below command to turn off the default http port.
sed -i '45s/^Listen 80/#Listen 80/' /etc/httpd/conf/httpd.conf

# Check the statement in the file at the given line number.
sed -n '45p' /etc/httpd/conf/httpd.conf

systemctl enable --now httpd

# firewall-cmd --add-rich-rule='rule family="ipv4" port port="8080" protocol="tcp"  source address="192.168.64.1/24" accept' --permanent


if grep -q enabled=1 /etc/yum/pluginconf.d/subscription-manager.conf
then
	sed -i "2s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/subscription-manager.conf
fi

mount -o loop,rw rhel8.iso /mnt

cp -r /mnt/Appstream /mnt/BaseOS /var/www/yumserver.rhel.com/

chown -R apache:apache /var/www/yumserver.rhel.com/*


cat > /etc/yum.repos.d/rhel.local.repo << EOF
[BaseOS.local]
name=BaseOS.local
baseurl=http://yumserver.rhel.com:8080/BaseOS
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[Appstream.local]
name=AppStream.local
baseurl=http://yumserver.rhel.com:8080/AppStream
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF

dnf clean all
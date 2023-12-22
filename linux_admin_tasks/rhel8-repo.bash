curl -s https://yum.oracle.com/RPM-GPG-KEY-oracle-ol8 > /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

cat > /etc/yum.repos.d/rhel.repo << EOF
[Latest]
name=Latest
baseurl=http://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

[AppStream]
name=AppStream
baseurl=http://yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

[Addons]
name=Addons
baseurl=http://yum.oracle.com/repo/OracleLinux/OL7/addons/x86_64
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

#[UEK_Release_7]
#name=UEK_Release_7
#baseurl=http://yum.oracle.com/repo/OracleLinux/OL8/UEKR7/x86_64
#enabled=1
#gpgcheck=1
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle

[EPEL]
name=EPEL
baseurl=http://yum.oracle.com/repo/OracleLinux/OL8/developer/EPEL/x86_64
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
EOF

dnf clean all
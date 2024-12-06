# Package management in RHEL 7 - 8

yum install <package_name>

yum remove <package_name>

# For RHEL 8 only to remove package completely.
yum erase <package_name> 

# Installs package over the internet.
yum install http://<package_name>.rpm 

# To get the dependencies list for a package.(For packages available in repo only.)
yum deplist <package_name> | grep provider | awk '{print $2}' | grep -v '.src' | sed -E 's/(-[0-9]+).*//' | sort | uniq

yum clean all # Clear all cache.

yum install <package_name>

# To download package only in provided directory.
yum install xterm --downloaddir=/root/xterm 

yum provides <command>

yum history


##############################
RPM

rpm -ivh <package_name>

# Lists the required dependencies.
rpm -qpR <package_name> 

# Lists what is inside in an RPM.
rpm -qpl <package_name> 

# To extract an RPM for local use.
rpm2cpio <package_name> | cpio -idmv 

# To extract an RPM for local use.
rpm -q <package_name>

rpm -qa | grep <package_name_matching_string>

# To install packages without dependencies.
rpm -ivh <package_name> --nodeps --force

# To query the package, to which the file is related.
rpm -qf <file>

# To get date wise history of packages installed in rhel 8.
rpm --last -q $(dnf history userinstalled | sed '1d') | column -t


##########################
Managing packages in rhel 8

dnf -y install <package_name>
dnf -y install http://<package_name>.rpm

dnf download <package_name>

dnf reinstall <package_name>

dnf erase <package_name>

dnf grouperase <package_name>  

dnf groupinfo <package_name>  

dnf groupinstall <package_name>

dnf grouplist <package_name>

dnf provides <command_name>

# To list the contents inside a rpm
dnf repoquery -l openvpn-auth-ldap

dnf history

# Use the history command to get the history_id
dnf history info <history_id>

# To apply critical updates only.
dnf upgrade --sec-severity=Critical

# To list the CVEs
dnf updateinfo info --sec-severity=Critical

# To mitigate CVEs
dnf check-update --cve CVE-2024-38538

# TO apply by the edvisior ID ELSA
dnf check-update --advisory ELSA-2024-5101

# To review the bug changelogs
dnf check-update --cve CVE-2024-2961 --changelogs

# To download a package and its dependencies in the current folder.
dnf download <package_name> --resolve
dnf download <package_name> --resolve --downloaddir /var/www/repos/ol-88/np-custom/Packages

# Extracting a package.
rpm2cpio <package_name> | cpio -idmv

# To get the dependencies list of a package.
# We could also use an HTTP link of the package.
dnf deplist <package_name> | grep provider | awk '{print $2}' | grep -v '.src' | sed -E 's/(-[0-9]+).*//' | sort | uniq

# To avoid the librepo warnings in CEntOS
dnf install python3-librepo -y

# List the available packages only.
dnf list installed bash

# Get the info of an installed package.
dnf info installed bash

# To search a package in a specific repo.
dnf list *postgres* --repoid appstream

# To list the specific collection of packages of a version
dnf module list postgresql

# To enable a certain stream of version.
dnf module enable postgresql:15

# To disable a repo
dnf config-manager --disable mongodb-org-6.0

# To enable a repo
dnf config-manager --enable mongodb-org-6.0

# To list list repos.
dnf repolist --enabled

dnf repolist --disabled

dnf repolist

# Completely sync a repo.
dnf reposync  --repoid=epel -p=epel

dnf group list

# Checks the whihc package requires the server to reboot.
dnf needs-restarting -r

dnf group info 'Minimal Install'

# Exclude a list of packages.
vim /etc/yum.conf
exclude=nano
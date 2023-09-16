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

# To query the dependent package of the library.
rpm -qf <full_library_path>



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

dnf history

# To apply critical updates only.
dnf upgrade --sec-severity=Critical

# Extracting a package.
rpm2cpio <package_name> | cpio -idmv

# To get the dependencies list of a package.
# We could also use an HTTP link of the package.
dnf deplist <package_name> | grep provider | awk '{print $2}' | grep -v '.src' | sed -E 's/(-[0-9]+).*//' | sort | uniq
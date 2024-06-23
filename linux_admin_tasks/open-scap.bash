# Get the CVEs list

# Install OpenSCAP packages
dnf install openscap openscap-utils scap-security-guide

wget https://linux.oracle.com/security/oval/com.oracle.elsa-ol8.xml.bz2

bzip2 -d com.oracle.elsa-ol8.xml.bz2

oscap oval eval –-results /tmp/result.xml --report /tmp/result-report.html /root/com.oracle.elsa-ol8.xml


#####

# To conduct a incorrect and unsecure settings on the server

dnf -y install openscap openscap-utils scap-security-guide

oscap xccdf eval --profile stig  \
--results /tmp/`hostname`-ssg-results.xml \
--report /var/www/html/`hostname`-ssg-results.html \
--cpe /usr/share/xml/scap/ssg/content/ssg-ol8-cpe-dictionary.xml \
/usr/share/xml/scap/ssg/content/ssg-ol8-xccdf.xml

#####


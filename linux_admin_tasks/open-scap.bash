# Get the CVEs list

# Install OpenSCAP packages
dnf install openscap openscap-utils scap-security-guide

wget https://linux.oracle.com/security/oval/com.oracle.elsa-ol8.xml.bz2

bzip2 -d com.oracle.elsa-ol8.xml.bz2

oscap oval eval –-results /tmp/result.xml --report /tmp/result-report.html /root/com.oracle.elsa-ol8.xml

oscap-ssh joesec@machine1 22 oval eval --report remote-vulnerability.html rhel-8.oval.xml

oscap oval eval --report vulnerability.html rhel-8.oval.xml
#####

# To conduct an incorrect and unsecure settings on the server

dnf -y install openscap openscap-utils scap-security-guide

oscap xccdf eval --profile stig  \
--results /tmp/`hostname`-ssg-results.xml \
--report /var/www/html/`hostname`-ssg-results.html \
--cpe /usr/share/xml/scap/ssg/content/ssg-ol8-cpe-dictionary.xml \
/usr/share/xml/scap/ssg/content/ssg-ol8-xccdf.xml

#####

dnf -y install httpd openscap-scanner scap-security-guide

ls /usr/share/xml/scap/ssg/content

oscap info /usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml

# Start the evaluation.
oscap xccdf eval --fetch-remote-resources --profile xccdf_org.ssgproject.content_profile_ism_o --results /tmp/scan-xccdf-results.xml /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml

# Generate an HTML report
oscap xccdf generate report /tmp/scan-xccdf-results.xml > /var/www/html/index.html


oscap xccdf generate fix --fix-type ansible --output remediation_playbook.yml --result-id "" /tmp/scan-xccdf-results.xml


ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix

ansible-playbook -i localhost, -c local remediation_playbook.yml



Title: ANSSI-BP-028 (minimal)
                                Id: xccdf_org.ssgproject.content_profile_anssi_bp28_minimal
								
								
Title: Centro Criptológico Nacional (CCN) - STIC for Red Hat Enterprise Linux 9 - Advanced
                                Id: xccdf_org.ssgproject.content_profile_ccn_advanced
                        Title: Centro Criptológico Nacional (CCN) - STIC for Red Hat Enterprise Linux 9 - Basic
                                Id: xccdf_org.ssgproject.content_profile_ccn_basic
                        Title: Centro Criptológico Nacional (CCN) - STIC for Red Hat Enterprise Linux 9 - Intermediate		

Title: PCI-DSS v4.0 Control Baseline for Red Hat Enterprise Linux 9
                                Id: xccdf_org.ssgproject.content_profile_pci-dss



Title: Australian Cyber Security Centre (ACSC) ISM Official
                                Id: xccdf_org.ssgproject.content_profile_ism_o								
								
:4,1777normal I    #								
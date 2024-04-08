# Enter to the root shell.
sudo -i

# List the available connections.
nmcli con show

# Modify the connection and add a secondary DNS server (IP address of the Active Directory server).
nmcli connection modify "System eth0" +ipv4.dns "172.31.83.180"

# Restart the NetworkManager daemon.
nmcli con up "System eth0"

# Verify the domain name.
getent hosts paulpranshu.org

# Veify the other DNS records.
host -t SRV _kerberos._udp.paulpranshu.org
host -t SRV _ldap._tcp.paulpranshu.org
host -t SRV _ldap._tcp.dc._msdcs.paulpranshu.org

# Install 
dnf -y install samba-common-tools realmd oddjob oddjob-mkhomedir sssd adcli krb5-workstation

# Make sure that time is synchronized on both the servers.
realm join --verbose paulpranshu.org

# Confirm the Administrator user of Windows.
getent passwd administrator@paulpranshu.org

# Switch the user to Administrator of Windows.
sudo su - administrator@paulpranshu.org
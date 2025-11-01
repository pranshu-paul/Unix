# Enter to the root shell.
sudo -i

# List the available connections.
nmcli con show

# Modify the connection and add a secondary DNS server (IP address of the Active Directory server).
nmcli connection modify eth0 +ipv4.dns 172.31.85.197

# Restart the NetworkManager daemon.
nmcli con up eth0

# Verify the domain name.
getent hosts paulpranshu.org

# Veify the other DNS records.
host -t SRV _kerberos._udp.paulpranshu.org
host -t SRV _ldap._tcp.paulpranshu.org

# To resolve the hostname of the directory server.
host -t SRV _ldap._tcp.dc._msdcs.paulpranshu.org

# Install the below packages.
# Additional pacakges openldap-clients authselect-compat
dnf -y install samba-common-tools realmd oddjob oddjob-mkhomedir sssd adcli krb5-workstation

# Discover the domain.
realm discover -v paulpranshu.org

# Make sure that time is synchronized on both the servers.
realm join --verbose paulpranshu.org

# Change the way to create home directories.
vim /etc/sssd/sssd.conf
use_fully_qualified_names = False
fallback_homedir = /home/%u

systemctl restart sssd

# Confirm the Administrator user of Windows.
getent passwd administrator@paulpranshu.org
id administrator@paulpranshu.org

# Switch the user to Administrator of Windows. (Both are same)
sudo su - administrator@paulpranshu.org
sudo su - administrator


## Powershell


New-ADUser -Name "Pranshu Paul" -SamAccountName "pranshu" -UserPrincipalName "pranshu@paulpranshu.org" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "PPaul" -SamAccountName "ppaul" -UserPrincipalName "ppaul@paulpranshu.org" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true

Add-ADGroupMember -Identity "Remote Desktop Users" -Members "pranshu"
Add-ADGroupMember -Identity "Remote Desktop Users" -Members "ppaul"

Unlock-ADAccount -Identity "pranshu"
Unlock-ADAccount -Identity "paul"

Add-ADGroupMember -Identity "Administrators" -Members "pranshu"

## Powershell

# On the linux machine
realm -v join -U pranshu paulpranshu.org


# To add groups in the domain.
realm permit -g 'Remote Desktop Users'@paulpranshu.org

# To withdraw a user or group from the realm.
realm permit --withdraw ppaul@paulpranshu.org

# To permit a user from the domain to login.
realm -v permit ppaul@paulpranshu.org
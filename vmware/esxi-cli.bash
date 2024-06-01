
# Print all the VMs.
vim-cmd vmsvc/getallvms

# Prints the summary of a vm by its id.
vim-cmd vmsvc/get.summary 32

# Print the system info.
esxcli system version get

# Prints a VM power status.
vim-cmd vmsvc/power.getstate 32

esxcli storage filesystem list

vim-cmd vmsvc/createdummyvm clivm /vmfs/volumes/datastore1

# ESXi top
esxtop

# To create a replica of a vm
# The vm should be configured to be replicated.
vim-cmd hbrsvc/vmreplica.create 5


# To enable vm replication
vim-cmd hbrsvc/vmreplica.enable 5  4 192.168.1.12 22

# Power on a VM
vim-cmd vmsvc/power.on 5

# To change the esxi hostname.
esxcli system hostname set --host=esxi
esxcli system hostname set --fqdn=esxi.example.com

# Print the hostname and FQDN
esxcli system hostname get

# Print the domain name.
hostname -d

# Print the FQDN.
hostname -f

# Print the ipv4 network.
esxcli network ip interface ipv4 get

# Print the connected NICs.
esxcli network nic list


# Test the port connectivity.
nc -zv google.com 80

# List the port groups.
esxcli network vswitch standard portgroup list

# Print the memory info.
esxcli hardware memory get

# Print the CPU info.
esxcli hardware cpu global get


# Print the users list.
esxcli system account list

# Print the firewall info.
esxcli network firewall get

# Print the uplinks available.
esxcli network vswitch standard list
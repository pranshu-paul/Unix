vim-cmd vmsvc/getallvms

# Prints the summary of a vm by its id.
vim-cmd vmsvc/get.summary 1

# Prints a VM power status.
vim-cmd vmsvc/power.getstate 1

esxcli storage filesystem list

vim-cmd vmsvc/createdummyvm clivm /vmfs/volumes/datastore1


# To create a replica of a vm
# The vm should be configured to be replicated.
vim-cmd hbrsvc/vmreplica.create 5


# To enable vm replication
vim-cmd hbrsvc/vmreplica.enable 5  4 192.168.1.12 22

# Power on a VM
vim-cmd vmsvc/power.on 5


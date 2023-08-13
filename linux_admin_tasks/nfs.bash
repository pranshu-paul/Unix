# NFS SERVER AND CLIENT SIDE CONFIGURATON IN RHEL


# SERVER SIDE CONFIGURATON

# Packages required for the NFS server.
nfs-utils

# Create an NFS share.
mkdir /nfs-share

# Change the permissions.
chmod 777 /nfs-share

# Set the umask.
umask 022

# Check the GID of the secondary group on both the SERVER and CLIENT sides.

# Add the following entry to /etc/exports.
/nfs-share 10.0.0.171(rw)

# Start the rpcbind and NFS daemon.
systemctl enable --now nfs-server rpcbind

# Initiate the NFS share publicly.
exportfs -arv

# Check the status of the NFS share.
exportfs

# Allow the NFS daemon through the firewall.
firewall-cmd --permanent --add-service={mountd,rpc-bind,nfs,nfs3}
firewall-cmd --add-service={mountd,rpc-bind,nfs,nfs3}
firewall-cmd --reload

# Verify the listening ports.
ss -lntp | grep -e State -e rpc -e mountd

# Inform SElinux about the NFS export.
setsebool -P nfs_export_all_rw 1


#########################
# CLIENT SIDE CONFIGURATON

# Required Packages.
nfs-utils

# For convenience, add an entry in /etc/hosts file.

# Verify available exports from the server.
showmount --exports srv_el8

# Create a mount point for the NFS server.
mkdir /nfs-client

# Mouting the nfs share.
mount -t nfs -o defaults srv_el8:/nfs-share /nfs-client

# In /etc/fstab.
srv_el8:/nfs-share	/nfs-client	nfs		defaults	0 0


##############################
# CHANGING PORT ON SERVER SIDE

# Add the following entry under [lockd] section in /etc/nfs.conf.
# Alternatively, nfs ports can also be specified in /etc/modprobe.d/lockd.conf
[lockd]

port=<tcp_port_number>
udp-port=<udp_port_number>


# Add a static port for rpc.statd under the [statd] section in /etc/nfs.conf.
[statd]

port=<port_number>

# ALLOW THE SPECIFIED PORTS IN /etc/nfs.conf THROUGH THE FIREWALL.
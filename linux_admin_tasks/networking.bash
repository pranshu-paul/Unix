# ONLY FOR RHEL AND OEL 8 AND 7 VERSIONS.
################ Sample /etc/hosts file ###################
# IP address	FQDN		hostname

103.240.90.232  dbprd.mmtc-pamp.com  dbprd
103.240.90.231  ebsprod.mmtc-pamp.com  ebsprod

ipcalc

# To list the network cards.
lshw -class network -short
lspci | grep network
dmesg | grep eth
lspci | grep -i ethernet

whoami # -- Shows the current user from which you are logged in.

# To show IP addresses.
ip addr show <DEVICE_NAME> | grep inet
ip addr show ens3 | grep inet
ip -4 a | grep inet # -- To get ipv4 address only.
hostname -I

# To configure the network in linux.
nmtui # Package for this command -- NetworkManager-tui

# To see the local area network IP addresses on your network.
ip neigh
arp -a # -- -a all IP address

/etc/sysconfig/network-scripts
ifcfg-<NETWORK_ALIAS>

# Sample ethernet file for rhel 6.
DEVICE=eth0
HWADDR=08:00:27:24:51:01
TYPE=Ethernet
UUID=5a370c36-4453-4c3e-9d03-3e8049e6a508
NAME=public
DEFROUTE=yes
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=none
PROXY_METHOD=none
BROWSER_ONLY=no
PREFIX=24
IPV6_DISABLED=yes
IPV6INIT=no
DNS1=192.168.168.56.2
IPADDR=192.168.56.5
NETMASK=255.255.255.0
NETWORK=192.168.56.1
BROADCAST=192.168.56.255
GATEWAY=192.168.56.2

# nmcli general commands.
nmcli dev connect ens160
nmcli dev disconnect ens160
nmcli con down dns160
nmcli con up dns160

nmcli connection modify enp0s8 +ipv4.routes "<destination>/<cidr> <next_hop>"
nmcli connection modify enp0s8 +ipv4.routes "0.0.0.0/0 192.168.56.0"

# Free DNS servers 8.8.8.8, 8.8.4.4 of google.com

# nmcli commands to assign static ip.
nmcli con modify <DEVICE_NAME> ipv4.method manual ipv4.addresses <IP_ADDRESS>/<CIDR> ipv4.gateway <GATEWAY> ipv4.dns <DNS_SERVER>

nmcli dev show ens224

nmcli con modify enp0s8 ipv4.method manual ipv4.addresses 192.168.56.100/24 \
ipv4.gateway 192.168.56.0 \
ipv4.dns 192.168.56.0 \
ipv6.method disabled \
autoconnect yes \
ipv4.never-default yes

nmcli con reload
nmcli con down ens224 && nmcli con up ens224

# To restart a connection.
nmcli con down ens3 && nmcli con up ens3

# To create a subnet.
nmcli connection add con-name <any_subnet_name> ifname <interface_name> type ethernet ip4 <ip_address>/<cidr> gw4 <gateway>

nmcli connection add con-name test_subnet \
ifname enp0s9 \
type ethernet \
ip4 192.168.101.1/27 \
gw4 192.168.101.1 \
autoconnect yes \
ipv4.never-default yes


# Create a new proxy connection
nmcli connection add type socks con-name "My SOCKS Proxy" ifname "*" ipv4.method auto ipv6.method auto

# Set the SOCKS proxy address and port
nmcli connection modify "My SOCKS Proxy" ipv4.proxy 127.0.0.1:1080 ipv6.proxy 127.0.0.1:1080

# Activate the SOCKS proxy connection
nmcli connection up "My SOCKS Proxy"


# To list on which ports the system is listening. -- l listening, n output in numbers, t TCP protocol, p PID.
# ss - shows system sockets.
# The below commands runs better with the root user.
ss -lntp # Package = iproute
ss -lntp | grep smon
netstat -lntp # -- For the old distros. # Package = net-tools


# DNS lookups.
dig <DOMAIN_NAME> # Package = bind-utils
dig google.com
dig -x 8.8.8.8 # -- Reverse DNS lookup.

dig @<SPECIFIC_DNS_SERVER> google.com
dig @8.8.8.8 google.com

dig TXT google.com
dig srv google.com # -- specific DNS record lookup.

host google.com # -- To get brief output.

# Public IP_ADDRESS lookup
curl ipinfo.io/<IP_ADDRESS>
curl ipinfo.io/8.8.8.8

# To find the server's public IP address.
curl ifconfig.co

# To see details about certificate.
openssl req -text -noout -in server.csr

# To show the certificate's information for the generated certificate.
openssl x509 -text -noout -in server.crt


# NetworkManager daemon.
# Restarting the network manager flushes /etc/resolve.conf file.
systemctl status NetworkManager
systemctl enable --now NetworkManager
systemctl restart NetworkManager

# The below commands can only be run by the root user.
echo "IP_ADDRESS	HOSTNAME.DOMAIN.TLD 	HOSTNAME" >> /etc/hosts
echo "$(hostname -i)	erpapps.supraits.com	erpapps" >> /etc/hosts

echo erpapps > /etc/hostname # For the old distros

hostnamectl set-hostname <HOSTNAME>
hostnamectl set-hostname erpapps



# Use the below commands to find package for command.
yum provides <COMMAND>
yum provides lvm
yum provides dig


#######################################################################################
# NETWORK BONDING.
# Bonding for low latency, high performance.
# Editing bond connection adding manual static ip to bond.
nmcli con add type bond ifname linbond0
nmcli con add type ethernet ifname ens161 master linbond0
nmcli con add type ethernet ifname ens256 master linbond0

nmcli con modify bond-linbond0 ipv4.method manual ipv4.addresses 192.168.64.24/24
nmcli con modify bond-linbond0 ipv4.gateway 192.168.64.2
nmcli con modify bond-linbond0 ipv4.dns 192.168.64.2

nmcli con mod bond-linbond0 mode active-backup

########################################################################################
# Another example of bonding.
nmcli connection add type bond con-name bond0 ifname bond0 bond.options "mode=802.3ad,miimon=100"
nmcli connection modify bond0 ipv4.addresses '192.168.1.100/24'
nmcli connection modify bond0 ipv4.gateway '192.168.1.1'
nmcli connection modify bond0 ipv4.method manual
nmcli connection add type ethernet slave-type bond con-name eth0 ifname eth0 master bond0
nmcli connection add type ethernet slave-type bond con-name eth1 ifname eth1 master bond0
nmcli connection add type ethernet slave-type bond con-name eth2 ifname eth2 master bond0
nmcli connection up eth0
nmcli connection up eth1
nmcli connection up eth2
nmcli connection up bond0

#########################################################################################
# Network teaming.
# Teaming for fault-taulrance.
# Packages required
NetworkManager-team teamd

nmcli con add type team con-name team0 ifname team0 team.runner activebackup
nmcli con add type ethernet slave-type team con-name team0-port1 ifname ens161 master team0
nmcli con add type ethernet slave-type team con-name team0-port2 ifname ens256 master team0
nmcli con mod team0 ipv4.addresses 192.168.1.150/24 ipv4.gateway 192.168.64.2 connection.autoconnect yes ipv4.method manual
nmcli connection modify team0 ipv6.method disabled
nmcli con down team0 && nmcli con up team0
ifup team0


##########################################################################################
# Another example of Teaming
nmcli connection add type team con-name team0 ifname team0 config '{"runner": {"name": "loadbalance", "tx_hash": [\"eth\", \"l3\", \"l4\"], "fast_rate"=true}}'
nmcli connection modify team0 team.link-watchers "name=ethtool"
nmcli connection modify team0 ipv4.addresses '192.168.1.100/24'
nmcli connection modify team0 ipv4.gateway '192.168.1.1'
nmcli connection modify team0 ipv4.method manual
nmcli connection add type team-slave con-name eth0 ifname eth0 master team0
nmcli connection add type team-slave con-name eth1 ifname eth1 master team0
nmcli connection add type team-slave con-name eth2 ifname eth2 master team0
nmcli connection up eth0
nmcli connection up eth1
nmcli connection up eth2
nmcli connection up team0

hostname -I
nmcli con mod team0 team.runner loadbalance # -- To change team runner.

teamdctl team0 state
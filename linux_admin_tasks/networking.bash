# ONLY FOR RHEL AND OEL 8 AND 7 VERSIONS.
################ Sample /etc/hosts file ###################
# IP address	FQDN		hostname

103.240.90.232  dbprd.mmtc-pamp.com  dbprd
103.240.90.231  ebsprod.mmtc-pamp.com  ebsprod

# To list available networks can be made in /16 network.
ipcalc 172.16.0.0/16 -S 20

# To fetch the MAC address of the IP
ip neigh show 192.168.1.11

# Ping and fetch the MAC of a target from source
timeout 5 arping -I ens33 -s 192.168.1.11 192.168.1.12

# To list the network cards.
lshw -class network -short
lspci | grep network
dmesg | grep eth
lspci | grep -i ethernet

whoami # -- Shows the current user from which you are logged in.

getent # To list all the ports from /etc/services

# To show IP addresses.
ip addr show <DEVICE_NAME> | grep inet
ip addr show ens3 | grep inet
ip -4 a | grep inet # -- To get ipv4 address only.
hostname -I

# To store packets in buffer during the transfer and recive.
nmcli con mod ens33 ethtool.ring-rx 8192
nmcli con mod ens33 ethtool.ring-tx 8192

nmcli con up ens3

# Shows the layer 2 recived and transffered packets.
ip -s link show ens3

# To configure the network in linux.
nmtui # Package for this command -- NetworkManager-tui

# To see the local area network IP addresses on your network.
ip neigh
arp -a # -- -a all IP address

# To get route for a specific ip.
ip route get 8.8.8.8


# To look for the ports
getent services | grep -w 443/tcp

# Configuration file location and name.
/etc/sysconfig/network-scripts/ifcfg-<NETWORK_ALIAS>

# To get the hardware address.
ip link show enp0s9 | grep link | awk '{print $2}'

# To add DNS servers with options
nmcli con mod ens3 +ipv4.dns "8.8.8.8 4.2.2.2"
nmcli con mod ens3 +ipv4.dns-options "attempts:1 timeout:1"
/etc/resolv.conf
nameserver 9.9.9.9
nameserver 208.67.222.222
# Qaud 9: 9.9.9.9
# Cisco: 208.67.222.222
options timeout:1 attempts:2
# To generate a UUID.
uuidgen

# Sample ethernet file for rhel 6,7, and 8.
DEVICE=enp0s9
HWADDR=08:00:27:51:77:b9
TYPE=Ethernet
UUID=820811e1-818a-499e-b535-1a29bd545f55
NAME=enp0s9
DEFROUTE=no
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=none
PROXY_METHOD=none
BROWSER_ONLY=no
PREFIX=24
IPV6_DISABLED=yes
IPV6INIT=no
DNS1=192.168.100.1
IPADDR=192.168.100.15
NETMASK=255.255.255.0
NETWORK=192.168.100.0
BROADCAST=192.168.100.255
GATEWAY=192.168.100.1

# nmcli general commands.
nmcli dev connect ens160
nmcli dev disconnect ens160
nmcli con down dns160
nmcli con up dns160

# Free DNS servers 8.8.8.8, 8.8.4.4 of google.com

# Create a VLAN
nmcli connection add type vlan0 dev ens3 id 100 ip4 10.0.0.65/26 gw4 10.0.0.1 ipv6.method disabled
nmcli connection add type vlan1 dev ens3 id 200 ip4 10.0.0.129/26 gw4 10.0.0.1 ipv6.method disabled

nmcli con up vlan0
nmcli con up vlan1

# Add the routes.
ip route add 10.0.0.128/26 via 10.0.0.1 dev ens3.100
ip route add 10.0.0.64/26 via 10.0.0.1 dev ens3.200

# Enable ip forwarding.
sysctl -w net.ipv4.ip_forward=1

# Verify the internal jump.
ssh -J 10.0.0.129:2169 10.0.0.65 -p 2169

# To add a DNS server to a live system.
nmcli con mod ens3 +ipv4.dns 8.8.8.8

nmcli con up ens3

# To remove a DNS server from a live system.
nmcli con mod ens3 -ipv4.dns 8.8.8.8

nmcli con up ens3

# nmcli commands to assign static ip.
nmcli con modify <CONNECTION_NAME> ipv4.method manual ipv4.addresses <IP_ADDRESS>/<CIDR> ipv4.gateway <GATEWAY> ipv4.dns <DNS_SERVER>

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

# To calculate a network addresses.
ipcalc 192.168.100.1/24 -S 27

nmcli connection add con-name <any_subnet_name> ifname <interface_name> type ethernet ip4 <ip_address>/<cidr> gw4 <gateway>

nmcli connection add con-name test_subnet \
ifname enp0s9 \
type ethernet \
ip4 192.168.101.1/27 \
gw4 192.168.101.1 \
autoconnect yes \
ipv4.never-default yes

# To create a virtual network interface card.
nmcli connection add type dummy ifname vnic0 con-name vnic0  ipv4.method manual ipv4.addresses 172.16.15.2/24 ipv6.method disabled

# Create a new proxy connection
nmcli connection add type socks con-name "My SOCKS Proxy" ifname "*" ipv4.method auto ipv6.method auto

# Set the SOCKS proxy address and port
nmcli connection modify "My SOCKS Proxy" ipv4.proxy 127.0.0.1:1080 ipv6.proxy 127.0.0.1:1080

# Activate the SOCKS proxy connection
nmcli connection up "My SOCKS Proxy"



# Disable IPv6
cat > /etc/sysctl.d/disable-ipv6.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF

# Other kernel parameters.
# Ignore all ipv4 icmp requests.
net.ipv4.icmp_echo_ignore_all = 1

# Ignore all ipv4 broadcast requests.
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Apply the changes.
sysctl --system

# To list on which ports the system is listening. -- l listening, n output in numbers, t TCP protocol, p PID.
# ss - shows system sockets.
# The below commands runs better with the root user.
ss -lntp # Package = iproute
ss -lntp | grep smon

ss -no state all '( dport = :2169 or sport = :2169 )'

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
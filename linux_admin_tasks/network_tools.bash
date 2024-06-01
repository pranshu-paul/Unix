# Network troubleshooting tools.

# TCP/IP layer wise.

# Physical Layer #
ip link show
nmcli dev connect <interface>
nmcli dev disconnect <interface>

nmcli device wifi connect <SSID> password <password>

ethtool ens3

# Datalink Layer #
tcpdump
tcpdump -i eth0 -e
tcpdump -nnei ens3

# Adjusts the maximum transmission unit (MTU).
# disbale ipv6
# net.core.somaxconn
# net.core.netdev_max_backlog
sysctl

ip link set dev ens3 addr 02:00:17:00:b8:5c

ip neigh show

ip neigh get 10.0.0.1 dev ens3

nmcli dev show ens3

nmcli con modify <connection_name> ifname <interface>

# Shows received, transferred packets. RX and TX
ip -s link show ens3

# ===== Network Layer ===== #
ipcalc 172.16.0.0/16 -S 20

tcpdump -i eth0 ip

# ICMP
ping

# My traceroute
mtr

# Traffic control.
tc

# By creating a simple proxy.
nc -l -p 8080 | nc <remote_host> 80

nmcli con modify <con_name> ipv4.addresses <ip>/<cidr>

nmcli con modify <con_name> ipv4.dns <dns_server>

# With the source or destination IP address; port, and protocol
nftables

# ip packet forwarding (NAT)
sysctl 

# Transport Layer #
ip tcp_metrics show
ip tcp_metrics show address 8.8.8.8

ss

netcat

tcpdump

nmcli con modify <con_name> ipv4.routes <route>

nmcli con add type vpn

# TCP congestion control
# Socket buffer size.
# TCP keepalive
# ip local port range
# net.ipv4.tcp_window_scaling
# net.ipv4.tcp_congestion_control
# net.ipv4.tcp_fin_timeout
# net.ipv4.tcp_tw_reuse
# net.ipv4.tcp_keepalive_time
# net.ipv4.tcp_syncookies
# net.ipv4.tcp_max_syn_backlog
sysctl


# With the port and protocol only.
nftables


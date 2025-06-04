# Linux Routing.

# To add permanent routes use nmcli.
nmcli connection modify enp0s8 +ipv4.routes "<destination>/<cidr> <next_hop> <metric>"
nmcli connection modify <connection_name> +ipv4.routes "<destination>/<cidr> <gateway> <metric>"
nmcli connection modify ens10f0 +ipv4.routes "172.19.8.0/24 172.19.8.140"
nmcli connection modify <connection_name> +ipv4.routes "0.0.0.0/0 10.0.2.2 100"

# To add temporary routes.
# Both are same.

ip route add <destination>/<cidr> via <gateway> dev <device_that_can_reach_gateway> src <source_ip_on_the_device> metric <metric>
ip route add 10.0.2.12 from 10.0.3.13 via 192.168.1.3
ip route add <target_ip> from <source_nic_ip> via <pingable_ip_of_the_other_machine>

ip route add default via 10.0.0.43 src 10.0.0.108 dev ens3 proto static metric 50
ip route add default via 172.19.8.140 src 172.19.8.0 dev ens3 metric 103
ip route add 0.0.0.0/0 via 10.0.0.43 src 10.0.0.108 dev ens3 metric 50

# To add between two nodes
ip route add <target_network>/<cidr> via <pingable_ip> dev ens36
ip route add 172.16.2.0/25 via 172.16.1.3 dev ens36

# To delete the default route.
ip route del default
ip route del default metric 100

# To get routes in netsta style in hexadecimal
cat /proc/net/route

# To get a list of the cached routes.
cat /proc/net/rt_cache

# To add a default route.
ip route add default via 192.168.0.1 metric 10

# To delete a route.
ip route del default via 10.0.0.66 dev ens3.100 proto static metric 101
ip route del 192.168.1.0/24 via 192.168.211.2 dev ens160

# To drop the outgoing traffic to a network.
ip route add blackhole 8.8.8.8

# No route to host.
ip route add unreachable 8.8.8.8

# Equal-cost multi-path (ECMP) Routing.
# For load balancing.
ip route add 10.0.0.0/24 via 192.168.0.1
ip route add 10.0.0.0/24 via 192.168.0.2

# To change a route.
ip route change 192.168.2.0/24 via 192.168.0.2

# To get the route for a destination.
ip route get 8.8.8.8

ip route get 8.8.8.8 from 192.168.1.19 dev ens33

# To flush the all routes temporarily.
ip route flush

# Creating a NAT instance and a gateway router.

# Router VM with two networks.
192.168.10.0/24
10.0.1.0/28

# Router IP address.
192.168.10.3
10.0.1.3

# Enable IP forwarding.
echo 1 > /proc/sys/net/ipv4/ip_forward

# Enable IP masquerading.
firewall-cmd --add-masquerade
firewall-cmd --runtime-to-permanent

# On the VMs accessing the gateway.

# On the VM with 10.0.1.0/28 network only.
ip route add 192.168.10.0/24 via 10.0.1.3

# On the VM with 192.168.10.0/24 network only.
ip route add 10.0.1.0/28 via 192.168.10.3

# To use the router as a NAT instance.
ip route add default via 10.0.1.3
ip route add default via 192.168.10.3

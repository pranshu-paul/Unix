# To install firewall-cmd.
# firewall-cmd uses netfilter at its backend.
dnf -y install firewalld

# To get more help about firewall.
man firewall-cmd
man 5 firewalld.conf

# List all current rules and ports defined.
firewall-cmd --list-all

# Firwall default behaviour.
# targets available ACCEPT, DROP, REJECT
firewall-cmd --permanent --set-target=DROP

# To make the all temporary changes permanent.
firewall-cmd --runtime-to-permanent

# Create firewall rules for an interface.
firewall-cmd --zone=trusted --add-interface=ens36
firewall-cmd --runtime-to-permanent

# Set the zone on the interface.
nmcli con mod ens36 connection.zone trusted
nmcli con up ens36

# List the rules in the zone.
firewall-cmd --zone=trusted --list-all

# To add a new port.
# This option adds port immediatley, but removes port after reboot.
# The below option is an example of stateless rule.
firewall-cmd --add-port=<port>/<protocol>

# To add rules while the firewall is not running.
firewall-offline-cmd --add-port=80/tcp

# To add, remove, and query icmp block.
# We could also use the option "--permanent".
firewall-cmd --add-icmp-block-inversion
firewall-cmd --remove-icmp-block-inversion
firewall-cmd --query-icmp-block-inversion


# To make changes persistant.
# This option doesn't let you to add port immediatley.
# The below option is an example of stateless firewall.
firewall-cmd --add-port=<port>/<protocol> --permanent

# Use this option after [--permanent] option.
firewall-cmd --reload

# To add a rich rule. (until next reboot)
# family type ipv6 ipv4.
# Options for rules {accept|reject|drop}.
firewall-cmd --add-rich-rule='rule family="ipv4" source address="<ip_address>[/<cidr>]" accept'

# To add a persistant rich rule.
# The below rules are examples of stateful firewall.
firewall-cmd --add-rich-rule='rule family="ipv4" source address="<ip_address>[/<cidr>]" accept' --permanent
firewall-cmd --add-rich-rule='rule family="ipv4" port port="8080" protocol="tcp"  source address="192.168.64.1" accept' --permanent
firewall-cmd --reload

# To remove rich-rule.
# Must be same as added.
firewall-cmd --remove-rich-rule='rule family="ipv4" source address="<ip_address>" accept'

# To add a port forward.
# --add-forward-port=port=<portid>:proto=tcp:toport=<portid>[:toaddr=<address>[/mask]]
firewall-cmd --zone=public --add-forward-port=port=443:proto=tcp:toport=8443:toaddr=10.0.0.45


# Important configuration file.
/etc/firewalld/firewalld.conf

# To see the enabled configuration of firewall.
grep -v -e '^#' -e '^$' /etc/firewalld/firewalld.conf

# Reload the firewall after any changes.
systemctl reload firewalld

# To enable the firewall port forward.
# Enable the ip_forward kernel parameter.
echo 1 > /proc/sys/net/ipv4/ip_forward

# Or, update the sysctl.conf file.
net.ipv4.ip_forward=1


# Prints the NICs attached to the public zone.
firewall-cmd --zone=public --list-interfaces
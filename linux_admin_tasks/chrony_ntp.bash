dnf -y install chrony

systemctl enable --now chronyd

# Uncomment and edit the below line at line number 23.
allow 192.168.100.1/24

sed -i '24i\allow 192.168.100.1/24' /etc/chrony.conf
sed -n '24p' /etc/chrony.conf

firewall-cmd --add-service=ntp
firewall-cmd --add-service=ntp --permanent

chronyc tracking

# Same steps for the client.
# Just add the below line.
# And do not add the "allow" line in the client.
server 192.168.100.6 iburst


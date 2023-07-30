Creating a DNS server.

# We can add multiple server entries in the zone files.

# Download the packages.
dnf -y install bind bind-utils

# Run the below commands to change the settings.
sed -i '11s/^listen-on/#listen-on/' /etc/named.conf
sed -n '11p' /etc/named.conf

sed -i '12s/^listen-on-v6/#listen-on-v6/' /etc/named.conf
sed -n '12p' /etc/named.conf

sed -i '19s#{ localhost; }#{ localhost; 192.168.100.0/24; }#' /etc/named.conf
sed -n '19p' /etc/named.conf

# Append the "/etc/named.conf" file with the below statements.
include "/etc/named/forward_custom.conf";
include "/etc/named/reverse_custom.conf";

# Create a custom forward file "/etc/named/forward_custom.conf"
zone "pauldb.net" IN {
     type master;
     file "forward.pauldb.net";
     allow-update { none; };
     allow-query { any; };
};

# Create a custom reverse file "/etc/named/reverse_custom.conf"
zone "100.168.192.in-addr.arpa" IN {
     type master;
     file "reverse.pauldb.net";
     allow-update { none; };
     allow-query { any; };
};


# Make a forword zone file.
vim /var/named/forward.pauldb.net

$TTL 1D
@                IN     SOA    srv01.pauldb.net.            root.pauldb.net. (
                                                            2014051001  ; serial
                                                            3600        ; refresh
                                                            1800        ; retry
                                                            604800      ; expiry
                                                            86400       ; minimum
)

; Name servers

@                 IN     NS    srv01.pauldb.net.
@                 IN     PTR   root.pauldb.net.

; Hostname to IP resolution

srv01               IN     A     192.168.100.6
6               IN     PTR   srv01.pauldb.net.

# Make a reverse zone file.
vim /var/named/reverse.pauldb.net

$TTL 1D
@                IN     SOA    srv01.pauldb.net.     		root.pauldb.net. (
                                                            2014051001  ; serial
                                                            3600        ; refresh
                                                            1800        ; retry
                                                            604800      ; expiry
                                                            86400       ; minimum
)

; Name servers

@                 IN     NS    srv01.pauldb.net.
@                 IN     PTR   root.pauldb.net.

; Hostname to IP resolution

srv01               IN     A     192.168.100.6
6               IN     PTR   srv01.pauldb.net.

# Run the below commands to check the configurations.
named-checkconf -z
named-checkzone pauldb.net /var/named/forward.pauldb.net
named-checkzone 192.168.100.6 /var/named/reverse.pauldb.net

systemctl restart named

# Add the below configuration in the directory "/etc/NetworkManager/conf.d"
[main]
dns=none

[ipv4]
dns=192.168.100.6;

# Add the below line as the First name server in the file "/etc/resolv.conf"
nameserver 192.168.100.6

firewall-cmd --add-port=53/udp --permanent
firewall-cmd --reload

# If creating two nodes
# Add the DNS entry using "nmtui"

systemd-resolve --flush-caches



Creating a DNS server.

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
zone "oswebadmin.com" IN {
     type master;
     file "forward.oswebadmin.com";
     allow-update { none; };
     allow-query { any; };
};

# Create a custom reverse file "/etc/named/reverse_custom.conf"
zone "100.168.192.in-addr.arpa" IN {
     type master;
     file "reverse.oswebadmin.com";
     allow-update { none; };
     allow-query { any; };
};


# Make a forword zone file.
vim /var/named/forward.oswebadmin.com

$TTL 1D
@                IN     SOA    www.oswebadmin.com.            root.oswebadmin.com. (
                                                            2014051001  ; serial
                                                            3600        ; refresh
                                                            1800        ; retry
                                                            604800      ; expiry
                                                            86400       ; minimum
)

; Name servers

@                 IN     NS    www.oswebadmin.com.
@                 IN     PTR   root.oswebadmin.com.

; Hostname to IP resolution

www               IN     A     192.168.100.3
100               IN     PTR   www.oswebadmin.com.

# Make a reverse zone file.
vim /var/named/reverse.oswebadmin.com

$TTL 1D
@                IN     SOA    www.oswebadmin.com.     	root.oswebadmin.com. (
                                                            2014051001  ; serial
                                                            3600        ; refresh
                                                            1800        ; retry
                                                            604800      ; expiry
                                                            86400       ; minimum
)

; Name servers

@                 IN     NS    www.oswebadmin.com.
@                 IN     PTR   root.oswebadmin.com.

; Hostname to IP resolution

www               IN     A     192.168.100.3
100               IN     PTR   www.oswebadmin.com.

# Run the below commands to check the configurations.
named-checkconf -z
named-checkzone oswebadmin.com /var/named/forward.oswebadmin.com
named-checkzone 192.168.100.3 /var/named/reverse.oswebadmin.com

systemctl restart named

# Add the below configuration in the directory "/etc/NetworkManager/conf.d"
[main]
dns=none

[ipv4]
dns=192.168.100.3;

# Add the below line as the First name server in the file "/etc/resolv.conf"
nameserver 192.168.100.3

firewall-cmd --add-port=53/udp --permanent
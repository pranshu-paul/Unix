# NFtables netfilter

nft add table inet main_table

nft add chain inet main_table input { type filter hook input priority filter \; }

nft -a list table inet main_table


# nft add rule inet <table_name> <chain_type> <protocol> <destination_port> <action>
nft add rule inet main_table input tcp dport 2169 accept

nft add chain inet main_table output { type filter hook output priority 0 \; policy accept \; }

nft add chain inet main_table OUTPUT { type filter hook output priority filter \; }

	

# nft add chain inet main_table INPUT { type filter hook input priority 0; policy drop; }
# To reject all the ports
nft add rule inet main_table INPUT reject with icmpx type port-unreachable

nft flush chain inet main_table INPUT


nft add chain inet main_table input { type filter hook input priority 0 \; policy drop \; }
nft add chain inet main_table input { type filter hook input priority filter \; }

nft -a list table inet main

nft delete rule inet main input handle 6

# To create a nat instance.
nft add table nat
nft add chain nat postrouting { type nat hook postrouting priority 100 \; }
nft add rule nat postrouting oifname \!= "lo" masquerade


# Sample nftables script.
#!/usr/sbin/nft -f

table inet main {
        chain input {
                type filter hook input priority filter; policy drop;
                ct state established,related accept
                iifname "lo" accept
                icmp type echo-request accept
                tcp dport 22 accept
        }
}
table ip nat {
        chain postrouting {
                type nat hook postrouting priority srcnat; policy accept;
                oifname != "lo" masquerade
        }
}


# Also enable packet-forwarding at the kernel level.
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/95-ipv4_forward.conf
sysctl --system


# It can also block (layer 7).
# based on the protocol: HTTP, SMTP, DNS

####
chain prerouting {
        type nat hook prerouting priority 0;
        # Redirect incoming traffic on port 8080 to internal server at port 80
        tcp dport 8080 redirect to :80
    }
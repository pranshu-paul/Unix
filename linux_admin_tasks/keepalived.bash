# Keepalived


# Install keepalived
dnf -y install keepalived

# Check version
keepalived --version

# Master node
global_defs {
    notification_email {
        envisior.support@nexgplatforms.com
    }
    notification_email_from alerts@nexgplatforms.com
    smtp_server 172.19.8.114 587
	smtp_port 587
    smtp_connect_timeout 30
    enable_script_security
    script_user mysql
}
vrrp_script chk_mysqld {
    script "pidof mysqld"
    interval 1
    weight -50
}
vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 51

        unicast_src_ip 172.19.8.197
        unicast_peer {
             172.19.8.198
        }

    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 5aa95619				# Password can only be of 8 characters.
    }
# CIDR should also be provided to avoid any inconsistencies in the network
    virtual_ipaddress {
        172.19.8.90/24 dev ens33
    }
    track_script {
        chk_mysqld
    }
}

# Backup node
# ================================================ #
global_defs {
    notification_email {
        envisior.support@nexgplatforms.com
    }
    notification_email_from alerts@nexgplatforms.com
    smtp_server 172.19.8.114 587
    smtp_connect_timeout 30
    enable_script_security
    script_user mysql
}
vrrp_script chk_mysqld {
    script "pidof mysqld"
    interval 1
    weight -50
}
vrrp_instance VI_1 {
    state BACKUP
    interface ens33
    virtual_router_id 51

        unicast_src_ip 172.19.8.198
        unicast_peer {
                172.19.8.197
        }

    priority 110
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 5aa95619
    }
# CIDR should also be provided to avoid any inconsistencies in the network
    virtual_ipaddress {
        172.19.8.90/24 dev ens33
    }
    track_script {
        chk_mysqld
    }
}

# Check the syntax
keepalived -t

# Start Keepalived
systemctl enable --now keepalived

# Command:
tcpdump -i ens33 -n -vvv -s0 -l 'ip proto 112'

# For any errors.
journalctl -r -t Keepalived_vrrp

Description:
The command captures VRRP (Virtual Router Redundancy Protocol) packets on the ens33 network interface.
This helps in monitoring the VRRP advertisements sent between routers to ensure high availability of routing paths.

Table of Data:
| Attribute               | Value                    |
|-------------------------|--------------------------|
| Interface               | ens36                    |
| Protocol                | VRRP (IP protocol 112)   |
| Packet Size             | 40 bytes                 |
| Advertisement Interval  | 1 second                 |
| Bandwidth Usage         | 320 bps                  |

Formula Used:
To calculate the bandwidth usage created by the VRRP advertisements:

Bandwidth (bps) = (Packet Size (bytes) * 8 (bits/byte)) / Interval (seconds)

For the given VRRP advertisements:

Bandwidth (bps) = (40 bytes * 8 bits/byte) / 1 second
Bandwidth (bps) = 320 bits per second

Explanation:
Interface: The network interface to capture VRRP packets (ens36).
Protocol: VRRP packets are identified by IP protocol number 112.
Packet Size: Each VRRP packet is 40 bytes in length.
Advertisement Interval: VRRP advertisements are sent every 1 second.
Bandwidth Usage: The network bandwidth used by these VRRP packets is 320 bits per second (bps), which is minimal and unlikely to cause network congestion.

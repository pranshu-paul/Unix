# List available netowrk interfaces.
tcpdump -D

# Capture all the traffic from the given interface.
tcpdump -nnvi ens3 -c 25

# Seeing Hex output
tcpdump -nnvXSs 0

# Captures packets based on source and destination
tcpdump src 10.0.0.43
tcpdump dst 10.0.0.108

# Captures all the packets on a specific network.
tcpdump net 10.0.0.0/24

# Capture all the packets to a host on a specific port.
tcpdump -nnv dst www.google.com and tcp port 443 -w output.pcap

# Avoid checksum
tcpdump -Knnv dst www.google.com and tcp port 443 -w output.pcap

# To read from a .pcap file.
tcpdump -nnr <file>.pcap

# Capture all UDP packets on the port 53.
tcpdump -nnv udp dst port 53

# Capture UDP packets from a specific host and port.
tcpdump -nvni ens3 udp and host 8.8.8.8 and port 53

# To capture ICMP packets.
tcpdump -nnvi ens33 icmp
tcpdump -nnvi ens33 src 172.19.8.113 and icmp

# Capture from a specific source to a specific destination and port.
tcpdump -nnvi ens33 src 172.19.4.103 and dst 192.168.1.2 and dst port 80
tcpdump -nnvi ens33 src 172.19.4.103

# Capture layer 2 ARP messages.
tcpdump -nnvi ens3 arp
tcpdump -nnvi ens34 arp

# Capture packets from a portrange.
tcpdump portrange 21-25

# To capture broadcast
tcpdump -i ens34 -nvn 'broadcast'

# Fetch ASCII text from the pcap.
tcpdump -nnr ncat.pcap -A

# Can also use strings.
strings ncat.pcap

# To read the pcap file using wireshark.
tshark -r ncat.pcap

tcpdump -i ens33 'ip[6:2] & 0x1fff != 0'


# From a particular src and dst and vice versa.
# Fetch only TCP flags SYN & ACK on the port 2777.
# And, avoid PUSH and PUSH ACK flags.
tcpdump -nn -i any '((src host 172.19.8.174 and dst host 172.19.8.181) or (src host 172.19.8.181 and dst host 172.19.8.174)) and tcp[tcpflags] & (tcp-syn|tcp-ack) != 0 and port 2777 and not tcp[tcpflags] & tcp-push != 0'
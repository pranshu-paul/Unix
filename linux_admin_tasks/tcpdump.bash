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
tcpdump -nnvi ens3 icmp

# Capture from a specific source to a specific destination and port.
tcpdump -i eth0 src 192.168.1.1 and dst 192.168.1.2 and dst port 80

# Capture layer 2 ARP messages.
tcpdump -nnvi ens3 arp

# Capture packets from a portrange.
tcpdump portrange 21-25
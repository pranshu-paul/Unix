# tcpdump a cli based utility to capture and analyze packets.


# tcpdump at the network layer
# Output strcture.
<< EOF
Time stamp
Layer 3 protocol
Source address with source port
Destination address with destination port
TCP flags
Sequence number
Window size (ACK number)
Options (If any are set)
Payload (The actual data)
EOF

# To capture the outgoing traffic to a specfic host and save it to a file.
tcpdump -vni 1 dst host google.com and port 80 and tcp  -w http.pcap

# To read a .pcap file. -n resolves DNS to IP, service to the port number.
# .pcap files can also be filtered.
tcpdump -nr http.pcap

# to analyze the actual data use -x HEX and -X for HEX ASCII
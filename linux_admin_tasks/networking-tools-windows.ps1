# Networking tools of windows powershell for linux admins.

# Sends 4 ICMP packets.
# Alternative: ping
Test-Connection google.com
Test-Connection 8.8.8.8

# Resolves DNS
# Alternative: nslookup
Resolve-DnsName google.com -type A
Resolve-DnsName google.com -type MX
Resolve-DnsName envisior.in -type MX
Resolve-DnsName google.com -Server 8.8.8.8 -type a

# Check port connectivity.
# Alternative: telnet, ncat
tnc google.com -port 443

# Traces the route.
# Alternatives: tracert
Test-NetConnection -ComputerName google.com -TraceRoute

# Get the details of the IP address of the wifi adapter.
Get-NetIPConfiguration -InterfaceAlias "Wi-Fi"
Get-NetIPConfiguration -InterfaceAlias "Ethernet"

# Get details of the link layer
Get-NetAdapter -Name "Wi-Fi"

# To get the default route.
Get-NetRoute -DestinationPrefix "0.0.0.0/0" -AddressFamily IPv4


# Clears the DNS cache.
Clear-DnsClientCache

# To get the details of an establish connection.
Get-NetTCPConnection -RemotePort 2169

# Get the DNS entries.
Get-DnsClientServerAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4
Get-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -AddressFamily IPv4
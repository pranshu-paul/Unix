# Configuring a Layer four load balancer.
# HAProxy: High Availability Proxy.

# Install HAProxy.
dnf -y install haproxy

# Add the below configuration in /etc/haproxy/conf.d/test.cfg
frontend sample_httpd
    bind *:443
    mode tcp
    timeout client 60s
    default_backend allservers

backend allservers
    timeout connect 10s
    timeout server 100s
    balance roundrobin
    mode tcp
    server node1 150.230.237.232:443 check
    server node2 144.24.111.213:443 check

# Start and enable the service.
systemctl enable --now haproxy

# Open the port on the firewall.
firewall-cmd --add-port=443/tcp
firewall-cmd --add-port=443/tcp --permanent
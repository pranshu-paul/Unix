# Prometheus Side #

# Create a user for prometheus

# Create the directory for configuration, libraries

# Download the tar ball of prometheus

# Copy the below files respectively.
# Binary
# Configuration
# Libraries
# Systemd Unit File.

# Promethues configuration file.


# The default Promethues config file is prometheus.yml

# Prometheus default port: 9090

# Grafana default port: 3000

# Default user name and password of Grafana.
# Username: admin
# Password: admin

# Configuring Grafana #

# Add a data source to prometheus.

# Create and import a dashboard by adding its dashboard ID. i.e. node_exporter.

# Set Stat values for the constant values.
# Set the text mode auto.
# Set the color mode to none.
# Disable the graph mode.

# In standard options.
# Change bytes to gigabytes in Units.

# Prom queries
# node_total - node_mem_available
# node_filesystem_size_bytes(mountpoints="/")
# node_filesystem_size_bytes(mountpoints="/") - node_filesystem_free_bytes(mountpoints="/")
# sum(rate(node_network_recieved_bytes_total[5m])
# rate(node_network_recvieved_packets_total{device="eth0"}[30s])
# rate(node_network_recvieved_packets_total{device="eth0"}[<interval>])
# rate(node_network_recvieved_packets_total{device="eth0"}[30s])
# sum(rate(node_network_transmit_bytes_total[5m])
# node_time_seconds - node_boot_time_seconds

# Show points: never

# In options
# Change the legend to 
VM: {{instance}}

# Target Side #

# Install node exporter on the target machines.
# Default port: 9100

# Start the service.



# Gauge
# Threshold in percentage
# Not available by default
# 0 - 50% green
# 51 - 70% yellow
# 70 - 100% red

# percentage usage: used/total * 100

# CPU
# Memory
# Swap

# Create a dashboard choose data source Prometheus
# (node_memory_total_bytes{instance="10.0.0.4:9100"} - node_memory_available_bytes{instance="10.0.0.4:9100"}) / node_memory_total_bytes{instance="10.0.0.4:9100" * 100
# (node_memory_total_bytes - node_memory_available_bytes) / node_memory_total_bytes * 100

# Create a memory dashboard for multiple VMs.
# (node_memory_total_bytes{instance="$node"} - node_memory_available_bytes{instance="$node"}) / node_memory_total_bytes{instance="$node" * 100

# Create a filesystem dashboard for multiple VMs.
# (node_filesystem_size_bytes{instance="$node", mountpoints"/"} - node_filesystem_free_bytes{instance="$node", mountpoints"/"}) / node_filesystem_size_bytes{instance="$node", mountpoints"/"} * 100

# Dashboard settings: create variables for the virtual machines.



# Blackbox exporter.

# Black box exporter port: 9115/tcp
# To monitor a website availability (Client Side).

# Metrics path to fetch from.
metrics path /probe

# Http codes to monitor.
module: http_2xx

# Taret to monitor
targets: https://google.com

# SSL expiry can be monitored of a website.

# SHows succes of the prob.
probe_success = 1

probe_http_status_code

# Value mappings.
# 1 = UP; color green
# 0 = DOWN; color red

# Graph mode none.
# Background color solid.


# DNS lookup time.
# PromQL
probe_dns_lookup_time_seconds

# Color mode: none

# To monitor SSL
probe_http_ssl

# To monitor the http duration
probe_http_duration_seconds

# Enable the legend visibility.
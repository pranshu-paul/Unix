# Prometheus - Grafana #

# Prometheus Side #

# Create a user for prometheus with a comment
useradd --no-create-home --shell /bin/false prometheus

# Create the directory for configuration, libraries
install -v -d -m 755 -o prometheus /etc/prometheus/{consoles,console_libraries}
install -v -d -m 755 -o prometheus /var/lib/prometheus

# Download the tar ball of prometheus
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.53.0-rc.1/prometheus-2.53.0-rc.1.linux-amd64.tar.gz

# Extract the TAR
tar -zxpvf prometheus-2.53.0-rc.1.linux-amd64.tar.gz && cd prometheus-2.53.0-rc.1.linux-amd64

# Copy the below files respectively.

# Binary
install -v -m 755 prometheus -o prometheus -g prometheus /usr/local/bin
install -v -m 755 promtool -o prometheus -g prometheus /usr/local/bin

# The default Promethues config file is prometheus.yml
# Prometheus configuration file.
# Configuration
vi /etc/prometheus/prometheus.yml
# Global config
: "

global:
  scrape_interval:     15s
  
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s	
    static_configs:
      - targets: ['localhost:9090']

  - job_name: "linux servers"
    scrape_interval: 5s	
    static_configs:
      - targets: ["10.122.0.2:9100"]
	
"

# Libraries
cp -pvr console_libraries/ /etc/prometheus/console_libraries
cp -pvr consoles/ /etc/prometheus/consoles

# Systemd Unit File.
vi /etc/systemd/system/prometheus.service

: "
[Unit]
Description=Prometheus Time Series Collection and Processing Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
"

# Start the service
systemctl daemon-reload
systemctl enable --now prometheus
systemctl status prometheus



# Prometheus default port: 9090

# Grafana default port: 3000

# Download grafana
wget https://dl.grafana.com/oss/release/grafana-11.0.0.linux-amd64.tar.gz
tar -zxvf grafana-11.0.0.linux-amd64.tar.gz

# RPM
dnf install -y https://dl.grafana.com/oss/release/grafana-11.0.0-1.x86_64.rpm

# Start the Grafana service
systemctl daemon-reload
systemctl enable --now grafana-server
systemctl status grafana-server


# Default user name and password of Grafana.
# Username: admin
# Password: admin

# Password set: Mysql#459

# Configuring Grafana #

# Change theme prometheus
Login icon;Top right --> Profile --> Preferences --> Interface theme; Light --> Save

# Change the favicon
cp -v Linux_mascot_tux.png  /usr/share/grafana/public/img/fav32.png
cp -v Linux_mascot_tux.png  /usr/share/grafana/public/img/apple-touch-icon.png

cp -v tux.svg  /usr/share/grafana/public/img/grafana_icon.svg

# Add a data source to prometheus.
Navigation Menu --> Add new connection --> Prometheus --> prometheus server URL -- Save

# Create and import a dashboard by adding its dashboard ID. i.e. node_exporter.; 1860
# Don't forget to save the dashboard
Navigation Menu --> Dashboards --> import dashboards --> Dashboard ID; 1860 --> Load --> Import

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

# ===== Target Side ===== #

# Install node exporter on the target machines.
# Default port: 9100

# Create a user for node_exporter
useradd --no-create-home --shell /bin/false node_exporter

# Download
curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

# Extract
tar -zxpvf node_exporter-0.18.1.linux-amd64.tar.gz && cd node_exporter-0.18.1.linux-amd64

# Copy the binary
install -v -m 755 -o node_exporter -g node_exporter node_exporter /usr/local/bin

# Create systemd unit file
vi /etc/systemd/system/node_exporter.service

: "
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
"

# Start the service.
systemctl daemon-reload
systemctl enable --now node_exporter
systemctl status node_exporter



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


# For multiple VMs
# For CPU
# For file system
# Job is from /etc/prometheus/prometheus.yml
(((sum by (instance) (node_memory_total_bytes{jobs="linux servers"})) - (sum by (instance) (node_memory_free_bytes{jobs="linux servers"})))) / (sum by (instance) (node_memory_total_bytes{jobs="linux servers"})) * 100

# For CPU usage use mode != idle
((sum by (instance) (node_cpu_seconds_total{jobs="Prod Servers", mode != "idle"})) / (sum by (instance) (node_cpu_total_seconds{jobs="Prod Servers"})) * 100

# For file system
(((sum by (instance) (node_filesystem_size_bytes{job="Prod Servers"})) - (sum by (instance) (node_filesystem_free_bytes{job="Prod Servers"}))) / (sum by (instance) (node_filesystem_size_bytes{jobs="Prod Servers"})) * 100

# Enter Custom Legend: Memory, CPU, File System

# Add field override
# For Value #A; Value#B; Value#C
Field With Name: LastNot Null

Cell options > Cell type; Gauge

Gauge display mode

Value display; Value color

Thresholds; Set threshold; 90 red; 70 Yellow;

Standard options > Display name

In transform data; search merge ; select Merge series / tables

In transform data; + Add another transformation; Group By: {
	Instance: Group by
	Value #A: Calculate: Last *
	Instance: Group by
	Value #B: Calculate: Last *
	Instance: Group by
	Value #B: Calculate: Last *
}
						

# Dashboard URL can be used to view the current utilization.


# Dashboards can be exported in JSON and then imported for the future use.
# To export the dashboard JSON
Home --> Dashboards --> <Dashboard name> --> Three dot menu --> Inspect --> Panel JSON

# # To import the JSON
Home --> Dashboard --> Import Dashboard --> Import via dashboard JSON model --> Load



# Kubernetes monitoring
# Important exporters: node-exporter-metrics
# kube-state-metrics: 

# Metrics --> Prometheus --> Grafana

# Run Promethues and Grafana with the Kubernetes cluster
kubectl get pods

kubectl create namspeace Kubernetes-monitoring

# Get the helm charts

helm repo list

# Search a repo
helm search repo


helm install <app_name> <kube-prom-stack> --namepsace <namepsace-created-earlier>

# Verify the services
kubectl get pods -n kubernetes-monitoring


kubectl get svc -n Kubernetes-monitoring

# Edit the config to get the public IP
kubectl edit svc -n Kubernetes-monitoring

# Change Type from CLusterIP to LoadBalancer to get a public IP


# Expose the service
kubctl expose svc monitoring-grafana -n kubernetes-monitoring



kubectl get secrets <monitoring_grafana_service> -n kubernetes-monitoring
kubectl describe-secrets secrets -n kubernetes-monitoring

echo <base_64> | base64 --decode



# Non-generic Grafana data sources

# Pushgateway to send data to grafan from any source such as bash scripts
# Port 9091
# Custom data send as a POST request --> PushGateway --> Promethues --> Grafana

# Pushgateway installtion
curl -OL https://github.com/prometheus/pushgateway/releases/download/v1.9.0/pushgateway-1.9.0.linux-amd64.tar.gz
tar -xvzf pushgateway-1.9.0.linux-amd64.tar.gz && cd pushgateway-1.9.0.linux-amd64

# Create a systemd unit file
vi /etc/systemd/system/pushgateway.service

: "
[Unit]
Description=Prometheus Pushgateway
Wants=network-online.target
After=network-online.target

[Service]
User=pushgateway
Group=pushgateway
Type=simple
ExecStart=/usr/local/bin/pushgateway

[Install]
WantedBy=multi-user.target
"

systemctl daemon-reload
systemctl enable --now pushgateway

# Reconfigure the promethues service
vi /etc/prometheus/prometheus.yml
# Global config
: "

global:
  scrape_interval:     15s
  
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s	
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'push gateway'
    scrape_interval: 10s	
    static_configs:
      - targets: ['localhost:9091']
	
"

# Restart prometheus
systemctl restart promethues

# Data is needed to be sent in key value pairs in JSON
ps aux | awk '{if (NR>1) print "cpu_usage{command=\""$11"\", pid=\""$2"\"}"}'

# Configura prometheus YAML file to pull the metric from the pushgateway




# Monitoring Cloud #

# Create a user for Grafana (entity)
# Grant permission to the user (for resources like ec2, lambda)
# Create an access key for the user of Grafana

# Set email config in grafana.ini
# Restart the grafana
# Ansible also allows for email integration

# Alerting in Grafana
# Create contact points


# Granfana uses sqlite to store suer credentials and all the data
# Copy the grafana.db to backup: /var/lib/grafana
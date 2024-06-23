# Prometheus Server

useradd -m -s /bin/false prometheus

cd /home/prometheus

id prometheus

install -v -d -m 755 -o prometheus /etc/prometheus/{consoles,console_libraries}
install -v -d -m 755 -o prometheus /var/lib/prometheus

curl -Lo prometheus-2.24.0.linux-amd64.tar.gz https://github.com/prometheus/prometheus/releases/download/v2.53.0-rc.1/prometheus-2.53.0-rc.1.linux-amd64.tar.gz

tar -zxpvf prometheus-2.24.0.linux-amd64.tar.gz && cd prometheus-2.24.0.linux-amd64

install -v -m 755 prometheus /usr/local/bin
install -v -m 755 promtool /usr/local/bin

vi /etc/prometheus/prometheus.yml

# Global config
: "

global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute. 
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute. 
  scrape_timeout: 15s  # scrape_timeout is set to the global default (10s).
# A scrape configuration containing exactly one endpoint to scrape:# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    static_configs:
    - targets: ['localhost:9090']
	
"
prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --web.config.file=/home/prometheus/web-config.yml

firewall-cmd --add-port=9090/tcp --permanent

cp -pvr console_libraries/ /etc/prometheus/console_libraries
cp -pvr consoles/ /etc/prometheus/consoles

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
	--web.config.file=/etc/prometheus/web-config.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
"
###

mkdir -p /home/prometheus/certs/example.com && cd /home/prometheus/certs/example.com

openssl req -x509 -newkey rsa:4096 -nodes -keyout example.com.key -out example.com.crt -subj "/CN=*.example.com"

chown -vR prometheus:prometheus /home/prometheus/certs

firewall-cmd --add-port=9090/tcp
firewall-cmd --add-port=9090/tcp --permanent

systemctl daemon-reload
systemctl enable --now prometheus
systemctl status prometheus
   
ss -lntp | grep prometheus

prometheus --version
   
##### Client Side #####
   
useradd -m -s /bin/false node_exporter

curl -Lo node_exporter-0.18.1.linux-amd64.tar.gz https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

tar -zxpvf node_exporter-0.18.1.linux-amd64.tar.gz && cd node_exporter-0.18.1.linux-amd64

install -v -m 755 -o node_exporter -g node_exporter node_exporter /usr/local/bin

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

firewall-cmd --add-rich-rule='rule family="ipv4" port port="9100" protocol="tcp"  source address="192.168.64.1" accept'
firewall-cmd --add-rich-rule='rule family="ipv4" port port="9100" protocol="tcp"  source address="192.168.64.1" accept' --permanent

systemctl daemon-reload
systemctl enable --now node_exporter
systemctl status node_exporter


### Alert Manager On the Server Side ###

curl -Lo alertmanager-0.26.0.linux-amd64.tar.gz https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-amd64.tar.gz

groupadd alertmanager

useradd -g alertmanager --no-create-home --shell /bin/false alertmanager

mkdir -p /etc/alertmanager/templates

mkdir /var/lib/alertmanager



tar -xvf alertmanager-0.26.0.linux-amd64.tar.gz

cd alertmanager-0.26.0.linux-amd64

cp alertmanager amtool /usr/bin

cp alertmanager.yml /etc/alertmanager/alertmanager.yml

chown alertmanager:alertmanager /etc/alertmanager
chown alertmanager:alertmanager /var/lib/alertmanager
chown alertmanager:alertmanager /usr/bin/amtool
chown alertmanager:alertmanager /etc/alertmanager/alertmanager.yml
chown alertmanager:alertmanager /usr/bin/alertmanager

vi /etc/systemd/system/alertmanager.service

: "
[Unit]
Description=AlertManager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.path /var/lib/alertmanager/

[Install]
WantedBy=multi-user.target
"
systemctl daemon-reload

systemctl enable --now alertmanager

systemctl status alertmanager

alertmanager --version

vi /etc/alertmanager/alertmanager.yml
: "
route:
        receiver: 'email-notifications'

receivers:
- name: 'email-notifications'
  email_configs:
      - to: 'paulpranshu@gmail.com'
        from: 'paulpranshu@outlook.com'
        smarthost: 'smtp.office365.com:587'
        auth_username: 'paulpranshu@outlook.com'
        auth_password: '<password>'

        send_resolved: false
"

chown -R alertmanager:alertmanager /etc/alertmanager

/etc/prometheus/cpu_thresholds_rules.yml

: '
groups:
  - name: CpuThreshold
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[1m])) * 100) > 60
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage on {{ $labels.instance }} is greater than 60%."
'

vim /etc/prometheus/prometheus.yml
: '
global:
  scrape_interval: 5s
  evaluation_interval: 5s

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
           - localhost:9093

rule_files:
  - "cpu_thresholds_rules.yml"

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node_exporter"
    scrape_interval: 5s
    static_configs:
      - targets: ["139.59.73.0:9100"]
'

systemctl restart prometheus

# Add a hosts entry in the hosts file.


# PromQL

# Cpu Monitoring Expession.
# expr: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 60

# Memory Monitoring Expression.
# expr: 100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) > 60

# File System Monitoring Expression.
# expr: 100 * (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes{mountpoint="/"})) > 50

# Instance is up or not.
# expr: up == 0
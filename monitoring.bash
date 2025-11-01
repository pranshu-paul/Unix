# Checks the log file prints it locally and searches locally.
ssh -q user@172.19.8.174 "timeout 30 tail -n 50 -f /app01/kannel/kannel.log" | grep --line-buffered -ow throughput | wc -l


#!/bin/bash

file="$1"
keyword="$2"
threshold="$3"

count=0
while true; do
	tail -n 0 -f "$file" | grep --line-buffered -w "$keyword" | while read line; do
	echo "SMS command here"		
		((count++))		
		if [ ${count} -eq ${threshold} ]; then
			break
		fi		
	done	
	sleep 30
done

# Create a unit file
export EDITOR=vim
systemctl edit service-monitor.service --full --force

###
[Unit]
Description=Checks keyword and Sends SMS
Wants=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/monit /var/log/secure sshd 5
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=monit

[Install]
WantedBy=multi-user.target
###

# ============================================================================== #

#!/bin/bash

file=/root/loop
keyword=failed
threshold=5

count=0

while true; do
	tail -n 0 -f "${file}" | grep --line-buffered -w "${keyword}" | while read line; do
		echo "SMS command here"		
		((count++))		
		if [ ${count} -eq ${threshold} ]; then
			break
		fi		
	done	
	sleep 30
done

# ============================================================================== #

#!/bin/bash

while true
do
	if ! ss -4lnt | grep -q :80; then
		echo "SMS command here"
	fi
	sleep 2
done

kill -19 <ppid> # To pause the process.

kill -18 <ppid> # To continue the process.
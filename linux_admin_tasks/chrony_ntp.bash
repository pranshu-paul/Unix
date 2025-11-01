# To set keyboard.
localectl status

# Set a system locale variable:
localectl set-locale LANG=en_US.UTF-8

# To set keymap to English India.
localectl set-keymap en_IN

# To check time with date.
timedatectl status

# To set timezone Asia/Kolkata.
TZ=Asia/Kolkata
timedatectl set-timezone "${TZ}"

# To work with a specific timezone.
# UTC (Universal Coordinated Time)
export TZ=Asia/Kolkata
export TZ=UTC

unset TZ

# Format: yyyymmdd
target_date=20230201

formatted_date=$(date -d "$target_date" +"%Y_%m_%d")

echo "$formatted_date"

#!/bin/bash

UPTIME_EPOCH=$(date -d "$(who -b | awk '{print $3 " " $4}')" +%s)
LAST_EPOCH=$(dmesg --decode | tail -n 1 | awk '{print $3}' | tr "[]" " ")
FINAL_EPOCH=$(echo "$UPTIME_EPOCH + $LAST_EPOCH" | bc)

date -d @$FINAL_EPOCH

# To get the boot epch
date -d "$(who -b | awk '{print $3 " " $4}')" +%s

# To get the date of a file.
date +%d%m%Y -r <file_name>

# To get a specific date.
date -d "7 days ago"

date -d "tommorrow"
date -d "yesterday"

date -d "7 days"
date -d "last week"
date -d "last monday"
date -d "last month"
date -d "last year"

date -d "next year"
date -d "next monday"
date -d "next month"
date -d "next year"

# Time expressions.
date -d "12 hours ago"

# Nest two hours
date -d "2 hours"

# Similar with minute and seconds.
date -d "last hour"
date -d "next hour"


dnf -y install chrony

systemctl enable --now chronyd

# Uncomment and edit the below line at line number 23.
allow 192.168.100.1/24

sed -i '24i\allow 192.168.100.1/24' /etc/chrony.conf
sed -n '24p' /etc/chrony.conf

firewall-cmd --add-service=ntp
firewall-cmd --add-service=ntp --permanent

# If the server is showing any time server with this ^* then the NTP clients can sync the time.

chronyc tracking

# Same steps for the client.
# Just add the below line.
# And do not add the "allow" line in the client.
# 0.in.pool.ntp.org :Indian NTP server
# 139.59.15.185 Digital Ocean India NTP server
# ntp.nic.in timeserver
server 192.168.100.6

# To check the connected clients.
chronyc clients


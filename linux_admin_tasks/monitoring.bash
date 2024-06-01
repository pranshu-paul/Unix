#!/bin/bash

log_file=/home/pranshu/out_$(basename $0)_$(date +%d_%b).log

# exec &>> ${log_file}

print_header() {
    echo -e "\n========================================================================================================================================="
    echo  " 				$1 "
    echo -e "========================================================================================================================================="
}

print_header " Date and time when the script is running."
date

print_header " Hostname"
hostname

print_header " Server IP Addresses."
ip -4 -br addr show | grep -w UP

print_header " Number of cores and CPU percentage"
echo -e "Number of cores: $(nproc)"

cpu_usage() {
first_reading=$(grep -w "^cpu" /proc/stat)
sleep 1
second_reading=$(grep -w "^cpu" /proc/stat)

read -r -a first_values <<< "$first_reading"
read -r -a second_values <<< "$second_reading"

total_time=0; total_idle=0; total_non_idle=0

for ((i = 1, j = 1; i < ${#first_values[@]}, j < ${#second_values[@]}; i++, j++))
do
    total_time=$((total_time + second_values[j] - first_values[i]))
    if [[ $i -eq 4 || $j -eq 4 || $i -eq 5  || $j -eq 5 ]]; then
        total_idle=$((total_idle + second_values[j] - first_values[i]))
    fi
done

total_non_idle=$((total_time - total_idle))

cpu_usage=$(awk "BEGIN {printf \"%.2f\", ($total_non_idle / $total_time) * 100}")

echo "CPU Percentage: $cpu_usage%"
}

cpu_usage

print_header " Memory usage."
free -hw

printf "\n%s" "Memory percentage: "
total=0
for (( i=0; i<1; i++ ))
do
    mem_usage=$(free | awk '/Mem/ {printf "%.2f\n", $3/$2 * 100.0}')
    total=$(awk "BEGIN {print $total + $mem_usage}")
    sleep 1
done

average=$(awk "BEGIN {printf \"%.2f\", $total / 5}")
printf "%s\n" "$average%"

printf "%s" "Swap percentage: "
total=0
for (( i=0; i<1; i++ ))
do
    swap_usage=$(free | awk '/Swap/ {printf "%.2f\n", $3/$2 * 100.0}')
    total=$(awk "BEGIN {print $total + $swap_usage}")
    sleep 1
done

average=$(awk "BEGIN {printf \"%.2f\", $total / 5}")
printf "%s\n" "$average%"

print_header " Currently logged in users, uptime, and load average."
w

export PS_FORMAT="ruser,pid,ppid,nice,wchan:25,pmem,pcpu,time:15,euser,stat,flags,stime,thcount,comm:25"
print_header " Top CPU consuming processes."
ps -e --sort=-pcpu | grep -v grep | head

print_header " Top Memory consuming processes."
ps -e --sort=-pmem | grep -v grep | head

print_header " Any zombie processes."
ps -e | grep Z | grep -v ps

print_header " Business specific processes."
ps -e | head -1; ps -e | grep -v ps | grep -E 'ksmppd|bearerbox|sqlbox|gluster|mysqld'

print_header " Number of open files."
lsof -n | wc -l

print_header " Number of processes."
ps -eLF | wc -l

print_header " I/O utilization."
vmstat -aw 2 5 | sed '3d'

print_header " Today failed logins."
sudo lastb -wi | grep -vwE 'btmp|^$'

print_header " Mount points, inodes with their file system and total storage."
export FIELD_LIST=source,fstype,itotal,iused,iavail,ipcent,size,used,avail,pcent,target
df -h --output=$FIELD_LIST --sync --total | grep -vE 'tmpfs|nfs4|fuse.glusterfs'

print_header " Failed units."
systemctl list-units --state=failed --all --no-pager

print_header " No. of established connection of processes."
sudo ss -Hntup state established | cut -d '"' -f 2 |  sort | uniq -c | sort -nr | column -t -N EstabCount,Process

print_header " Data packets statistics."
for nic in $(nmcli con sh --active | sed '1d' | awk '{print $4}'); do
	ip -stat addr show "$nic"
done

print_header " Program-Crash-Report"
journalctl -r -t systemd-coredump -S today | grep -w systemd-coredump
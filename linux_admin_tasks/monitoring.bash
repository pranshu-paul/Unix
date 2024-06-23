#!/bin/bash

# Required Packages: yum-utils, sysstat

log_file=/home/pranshu/out_$(basename $0)_$(date +%d_%b).log

# exec &>> ${log_file}

print_header() {
    echo -e "\n=============================================================================================================================================="
    echo  " 				$1 "
    echo -e "==============================================================================================================================================\n"
}

print_header " Script Start Date and Time "
date

print_header " Hostname "
hostname

print_header " Server IP Addresses "
ip -4 -br addr show | cut -d '/' -f 1 | grep -w UP | awk '{print $1 "\t" $3}'| column -t -N NIC,IP

print_header " Total Cores CPU Percentage "
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


printf "Total Cores: %s, CPU Precentage: %s\n" "$(nproc)" "$cpu_usage%"
}

cpu_usage

print_header " Memory Swap Percentage "
total=0
for (( i=0; i<1; i++ ))
do
    mem_usage=$(free | awk '/Mem/ {printf "%.2f\n", $3/$2 * 100.0}')
    total=$(awk "BEGIN {print $total + $mem_usage}")
    sleep 1
done

mem_average=$(awk "BEGIN {printf \"%.2f\", $total / 5}")

total=0
for (( i=0; i<1; i++ ))
do
	swap_size=$(grep SwapTotal /proc/meminfo | awk '{print $2}')
	
	if [ "$swap_size" -eq 0 ]; then
		swap_average="Not Enabled"
		break
	else
		swap_average=$(awk "BEGIN {printf \"%.2f\", $total / 5}")%
	fi
	
    swap_usage=$(free | awk '/Swap/ {printf "%.2f\n", $3/$2 * 100.0}')
    total=$(awk "BEGIN {print $total + $swap_usage}")
    sleep 1
done

printf "Memory Percentage: %s, Swap Percentage: %s\n" "$mem_average%" "$swap_average"

print_header " Server Uptime "
uptime -p

print_header " Current Logged-on Users "
who -uH | column -t

# Process flags.
# 1 forked but didn't exec
# 4 used super-user privileges
# 5 both
# 0 none
export PS_FORMAT="ruser,pid,ppid,nice,wchan:25,pmem,pcpu,time:15,euser,state=STATE,flags=FLAGS,stime,thcount,comm:25"
print_header " Top CPU Consuming Processes"
ps -e --sort=-pcpu | grep -v grep | head -5

print_header " Top Memory Consuming Processes "
ps -e --sort=-pmem | grep -v grep | head -5

print_header " Zombie Processes "
ps -e | grep Z | grep -v ps

print_header " Business Specific Processes "
ps -e | head -1; ps -e | grep -v ps | grep -wE 'ksmppd|bearerbox|sqlbox|gluster?d?f?s?d?|mysqld|redis-server|node|mongod|ora_smon_nexgol|screen'

print_header " Current Open File Descriptors "
total=0
for pid in /proc/[0-9]*; do
    if [ -d "$pid/fd" ]; then
        count=$(ls -1 "$pid/fd" | wc -l)
        total=$((total + count))
    fi
done
echo "Hard Limit: $(ulimit -Hn), Current Usage: $total"

print_header " Current Processes/Threads Count "
echo "Hard Limit: $(ulimit -Hu), Current Usage: $(ps -eLF | wc -l)"

print_header " I/O Utilization "
vmstat -t -w -S M 2 4 -y | sed '1,2d' | column -t -N Run,Block,Swap,FreeMem,BuffMem,CacheMem,SwpIn,SwpOut,BlkIn,BlkOut,Int,CtxSwtch,Usr,Sys,Idle,Wait,Steal,Date,Time

print_header " Top Process Context Switching  "
pidstat -w 1 2 | grep -w Average | grep -vE 'grep|tail|pidstat' |sed '1d' | sort -r -k 4n | tail -5 | awk '{ $1=""; print }' | column -t -N UID,PID,cswch/s,nvcswch/s,Command

print_header " Block Drive Utilization "
sar -pd 1 4 | grep -w Average | awk '{ $1=""; print }' | column -t

print_header " Today Failed Logins "
sudo lastb -s today -wi | grep -vwE 'btmp|^$' | column -t -N User,TTY,From,Day,Mon,Date,TimeIn,_,TimeEnd,Duration

print_header " File System Inodes Usage "
export FIELD_LIST=source,fstype,itotal,iused,iavail,ipcent,size,used,avail,pcent,target
df -h --output=$FIELD_LIST --sync --total | grep -vE 'tmpfs|nfs4|fuse.glusterfs'

print_header " Established Connection Count By Processes "
sudo ss -Hntup state established | cut -d '"' -f 2 |  sort | uniq -c | sort -nr | column -t -N EstabCount,Process

print_header " Data Packets Statistics "
sar -n DEV 1 4 | grep -w Average | awk '{ $1=""; print }' | column -t

print_header " Program Crash Report "
journalctl -r -t systemd-coredump -S yesterday | grep -w systemd-coredump

print_header " Out Of Memory Killed Procceses "
journalctl -r -t kernel -S yesterday | grep 'Out of memory'
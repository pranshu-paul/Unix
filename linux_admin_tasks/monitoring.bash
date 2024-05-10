#!/bin/bash

log_file=/home/pranshu/out_$(basename $0)_$(date +%d_%b).log

exec &>> ${log_file}

echo -e "\nDate and time when the script is running."
date

echo -e "\nHostname, OS version, CPU architecture, and kernel version."
hostnamectl

echo -e "\nNICs breifing."
ip -4 -br addr show

echo -e "\nKernel routing table."
ip route show

echo -e "\nNumber of CPU(s), Socket(s), and Core(s) per socket."
lscpu | grep -E '^CPU\(s\)|Socket|Core\(s\)'

echo -e "\nCPU percentage."
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
    if [[ $i -eq 4 || $i -eq 5 || $j -eq 4 || $j -eq 5 ]]; then
        total_idle=$((total_idle + second_values[j] - first_values[i]))
    fi
done

total_non_idle=$((total_time - total_idle))

cpu_usage=$(awk "BEGIN {printf \"%.2f\", ($total_non_idle / $total_time) * 100}")

echo "$cpu_usage"
}

cpu_usage

echo -e "\nMemory usage."
free -hw

echo -e "\nMemory percentage."
mem_usage() {
readarray -t memory <<< $(awk '{print $2}' /proc/meminfo)

mem_total=0; mem_free=0; buffers=0; cached=0

for (( i = 0; i < ${#memory[@]}; i++ ))
do
	if [[ $i -eq 0 ]]; then
		mem_total=${memory[$i]}
	elif [[ $i -eq 1 ]]; then
		mem_free=${memory[$i]}
	elif [[ $i -eq 3 ]]; then
		buffers=${memory[$i]}
	elif [[ $i -eq 4 ]]; then	
		cached=${memory[$i]}
	fi
done
	mem_used=$((mem_total - (mem_free + buffers + cached)))
	memory_usage=$(awk "BEGIN {printf \"%.2f\", ($mem_used / ($mem_total)) * 100}")

echo "$memory_usage"
}
mem_usage

export PS_FORMAT="ruser,pid,ppid,nice,wchan:25,pmem,pcpu,time:15,euser,stat,flags,stime,thcount,comm:25"
echo -e "\nTop CPU consuming processes."
ps -e --sort=-pcpu | grep -v grep | head

echo -e "\nTop Memory consuming processes."
ps -e --sort=-pmem | grep -v grep | head

echo -e "\nProcesses running other than root."
ps -e | grep -v ^root

echo -e "\nAny zombie processes."
ps -e | grep Z | grep -v grep

echo -e "\nI/O utilization."
vmstat -aw 2 5 | sed '3d'

echo -e "\nUptime and load average."
uptime

echo -e "\nToday reboots"
last reboot -s today | head -15

echo -e "\nToday failed logins."
sudo lastb -s today | head -15

echo -e "\nToday logins."
sudo last -s today | head -15

echo -e "\nMount with their file system and total storage."
df -hT --total

echo -e "\nPhysical volumes"
sudo pvdisplay

echo -e "\nVolumes groups and physical volumes in a group."
sudo vgdisplay

echo -e "\nLogical volumes on a volume group."
sudo lvdisplay

echo -e "\nFailed units."
systemctl list-units --state=failed --all | cat


echo -e "\nSockets that are listening."
sudo ss -lntup

echo -e "\nEstablished connections."
ss -sntp

echo -e "\nData packets statistics."
ip -stat addr

echo -e "\nError logs"
journalctl -r -S today -p err | head -20

echo -e "\nAlert logs"
journalctl -r -S today -p alert | head -20
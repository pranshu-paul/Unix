#!/bin/bash

source /home/pranshu/scripts/functions
source /home/pranshu/scripts/constants

user=pranshu
waiting=2
port=22

declare -a source_hosts=(
"172.19.8.151"
"172.19.8.152"
)

declare -a target_hosts=(
"172.19.8.158"
"172.19.8.161"
"172.19.8.166"
"172.19.8.167"
)

size=4
count=1
timeout=3
interval=1

available_hosts=/tmp/$(basename $0)_icmp_available_hosts_$$
log_dir=/home/$(whoami)/scripts/logs
log_file="${log_dir}/$(basename $0)_$(date +%d_%b_%H%M%S).log"
service_stat_loc=/home/$(whoami)/scripts/locks

exec &> >(tee -a "$log_file")

mkdir -pv "$(dirname $log_file)"

check_hosts() {
local source_host="$1"

        nc -zv -w "$waiting" "$source_host" "$port" &> /dev/null

        if [ "$?" -ne 0 ]; then
                log "Unable to SSH to $source_host" "$ERROR"
                send_message "$source_host" SSH Down Emergency
                echo down > $service_stat_loc/$(basename $0_${source_host}).lock
                return 1
        elif [ -e $service_stat_loc/$(basename $0_${source_host}).lock ]; then
                log "Able to connect $source_host through SSH."
                send_message "$source_host" SSH Up None
                log "Removing the lock file."
                rm -fv $service_stat_loc/$(basename $0_${source_host}).lock
        fi

                echo "$source_host" >&3

return "$?"
}

process_hosts() {
        local -n hosts_array=$1
        local -n other_hosts=$2

        exec 3> "$available_hosts"

        for host in "${hosts_array[@]}"; do
                check_hosts "$host" &
        done

        wait

        exec 3>&-
        exec 3< "$available_hosts"
        mapfile -t working_sources <&3
        : > /proc/self/fd/3
        exec 3<&-
        rm -f "$available_hosts"
        exec 3> "$available_hosts"

        for host in "${other_hosts[@]}"; do
                check_hosts "$host" &
        done

        wait
        exec 3>&-
        exec 3< "$available_hosts"
        mapfile -t working_targets <&3
        : > /proc/self/fd/3
        exec 3<&-
        rm -f "$available_hosts"
        check_icmp working_sources working_targets
        unset working_sources working_targets
}


send_icmp() {
local source_host="$1"
local target_host="$2"

    variables=(source_host target_host size count timeout interval waiting user port)

    for var in "${variables[@]}"; do
        if [ -z "${!var}" ]; then
            log "Error: $var is not provided." "$ERROR"
            return 1
        fi
    done

ssh -o ConnectTimeout="$waiting" -q -T -l "$user" "$source_host" -p "$port" "ping -q -s $size -c $count -w $timeout -i $interval $target_host" &> /dev/null
exit_code="$?"

        if [ "${exit_code}" -ne 0 ]; then
                        log "Unable to send ICMP from $source_host to ${target_host}" "${exit_code}"
                        echo down > $service_stat_loc/$(basename $0_${source_host}_${target_host}).lock
                        send_message "$source_host to $target_host" Ping Down Emergency
        elif [ -e $service_stat_loc/$(basename $0_${source_host}_${target_host}).lock ]; then
                        log "Able to send ICMP from $source_host to ${target_host}" "${exit_code}"
                        send_message "$source_host to $target_host" Ping Up None
                        log "Removing the lock file."
                        rm -fv $service_stat_loc/$(basename $0_${source_host}_${target_host}).lock
        else
                log "Able to send ICMP from $source_host to ${target_host}" "${exit_code}"
        fi

return "$?"
}

check_icmp_hosts() {
local host="$1"
local -n target="$2"

for trgt in "${target[@]}"; do
	send_icmp "$host" "$trgt" &
done

wait
}

check_icmp() {
local -n source="$1"
local -n int_target="$2"
local i=0

    for source_host in "${source[@]}"; do
        check_icmp_hosts "$source_host" int_target &
    done

wait

return "$?"
}

main() {
echo -e "Executing $(basename $0) at $(date '+%b %d %H:%M:%S')"

process_hosts source_hosts target_hosts
process_hosts target_hosts source_hosts

get_execution_time
}

main

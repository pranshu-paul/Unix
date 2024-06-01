#!/bin/bash

# SSH connection details
user=pranshu
waiting=2
port=22

declare -a source_hosts=(
"172.19.8.151"
"172.19.8.152"
)

declare -a target_hosts=(
"172.19.4.103"
"172.19.8.167"
)

# ICMP parameters
size=4
count=1
timeout=3
interval=1

# Global directives
error=1
available_hosts=/tmp/$(basename $0)_available_hosts_$$

# SMS API details.
api_url="https://api2.nexgplatforms.com/sms/1/text/query"
username="NexGAlrT"
password="Happy@1234"
from="NXGART"
to="919873514389,918318867792,919958887630,919888632435"
indiaDltContentTemplateId="1207171507167956290"
indiaDltPrincipalEntityId="1201164455577917424"

log_dir=/home/$(whoami)/scripts/logs
log_file="${log_dir}/$(basename $0)_$(date +%d_%b_%H%M%S).log"
service_stat_loc=/home/$(whoami)/scripts/locks

exec &>> "$log_file"

mkdir -pv "$(dirname $log_file)"

send_message() {
local service=$2
local message="Dear TechOps,

Service: "$service"
Host: "$1"
Severity level: "$4"
State: "$3"
Date/Time: $(date "+%d %b %Y %H:%M")

Thanks and Regards,
nexG Platforms."

response=$(curl -L -s -G \
--data-urlencode "username=$username" \
--data-urlencode "password=$password" \
--data-urlencode "from=$from" \
--data-urlencode "to=$to" \
--data-urlencode "indiaDltContentTemplateId=$indiaDltContentTemplateId" \
--data-urlencode "indiaDltPrincipalEntityId=$indiaDltPrincipalEntityId" \
--data-urlencode "text=$message" \
"$api_url"
)

log "SMS API Response"
echo "$response" | jq
}

log() {
local message="$1"
local exit_code="$2"
local timestamp="$(date '+%b %d %H:%M:%S')"
local log_entry=""

        if [ -n "$exit_code" ] && [ "$exit_code" -ne 0 ]; then
                log_entry="[ERROR] - Exit code ${exit_code} - ${timestamp} - ${message}"
        elif [ -n "$exit_code" ] && [ "$exit_code" -eq 0 ]; then
                log_entry="[SUCCESS] - Exit code ${exit_code} - ${timestamp} - ${message}"
        else
                log_entry="[INFO] - ${timestamp} - ${message}"
        fi

echo -e "$log_entry"
}

check_hosts() {
local source_host="$1"

	nc -zv -w "$waiting" "$source_host" "$port" &> /dev/null
	
	if [ "$?" -ne 0 ]; then
		log "Unable to SSH to $source_host" "$error"
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

    # Close the file descriptor
    exec 3>&-

    # Open the file descriptor for capturing the array.
    exec 3< "$available_hosts"

    mapfile -t working_sources <&3

    : > /proc/self/fd/3

	# Close the file descriptor.
    exec 3<&-
	
	rm -f "$available_hosts"
	
	exec 3> "$available_hosts"
	
	for host in "${other_hosts[@]}"; do
        check_hosts "$host" &
    done
	
	wait
	
	# Close the file descriptor
    exec 3>&-

    # Open the file descriptor for capturing the array.
    exec 3< "$available_hosts"

    mapfile -t working_targets <&3
	
	: > /proc/self/fd/3
	
	# Close the file descriptor.
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
            log "Error: $var is not provided." "$error"
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

check_icmp() {
local -n source="$1"
local -n target="$2"
local -a pids=( )
local -a exit_codes=( )
local i=0

    for source_host in "${source[@]}"; do
		for target_host in "${target[@]}"; do
			send_icmp "$source_host" "$target_host" &
        done
    done

wait

return "$?"
}

get_execution_time() {
    duration="$SECONDS"
    hours=$((duration / 3600))
    minutes=$((duration % 3600 / 60))
    seconds=$((duration % 60))
    echo -e "\n$(basename $0): execution time: ${hours} hour(s) ${minutes} minute(s) ${seconds} second(s)"
}

main() {
echo -e "Executing $(basename $0) at $(date '+%b %d %H:%M:%S')"

process_hosts source_hosts target_hosts
process_hosts target_hosts source_hosts

get_execution_time
}

main
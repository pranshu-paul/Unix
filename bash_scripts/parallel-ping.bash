#!/bin/bash

# SSH connection details
user=pranshu
waiting=10
port=2169

declare -a source_hosts=(
"141.148.218.174"
)

declare -a target_hosts=(
"8.8.8.8"
"8.8.4.4"
"4.2.2.2"
"4.2.2.4"
)

# ICMP parameters
size=4
count=1
timeout=5
interval=1

# Global directives
error=1

log() {
local message="$1"
local exit_code="$2"
local timestamp="$(date '+%b %d %H:%M:%S')"
local log_entry=""

	if [ -n "$exit_code" ] && [ "$exit_code" -ne 0 ]; then
		log_entry="\n[ERROR] - Exit code ${exit_code} - ${timestamp} - ${message}"
	elif [ -n "$exit_code" ] && [ "$exit_code" -eq 0 ]; then
		log_entry="\n[SUCCESS] - Exit code ${exit_code} - ${timestamp} - ${message}"
	else
		log_entry="\n[INFO] - ${timestamp} - ${message}"
	fi

echo -e "$log_entry"
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
return $?
}

check_icmp() {
local -n source="$1"
local -n target="$2"
local -a pids=( )
local -a exit_codes=( )
local i=0

	for source_host in "${source[@]}"; do
	
		for target_host in "${target[@]}"; do
			log "Sending ICMP from $source_host to $target_host"
			send_icmp "$source_host" "$target_host" &
			pids+=("$!")
		done
		
    done

	for pid in "${pids[@]}"; do
		wait "$pid"
		exit_codes+=("$?")
	done

	for source_host in "${source[@]}"; do
	
		for target_host in "${target[@]}"; do
			
			exit_code="${exit_codes[i]}"
			
			if [ "${exit_codes[i]}" -eq 255 ]; then
				log "Unable to SSH to $source_host" "${exit_codes[i]}"
				echo "SMS command here"
				(( i+="${#target[@]}" ))
				continue 2
			elif [ "${exit_codes[i]}" -ne 0 ] && [ "${exit_codes[i]}" -ne 255 ]; then
				log "Unable to send ICMP from $source_host to ${target_host}" "${exit_codes[i]}"
				echo "SMS command here"
			else
				log "Able to send ICMP from $source_host to ${target_host}" "${exit_codes[i]}"
			fi
			
			(( i++ ))		
		done
		
	done

return $?
}

get_execution_time() {
    duration=$SECONDS
    hours=$((duration / 3600))
    minutes=$((duration % 3600 / 60))
    seconds=$((duration % 60))
    echo -e "\n$(basename $0): execution time: ${hours} hour(s) ${minutes} minute(s) ${seconds} second(s)"
}

main() {
echo -e "Executing $(basename $0) at $(date '+%b %d %H:%M:%S')"
check_icmp source_hosts target_hosts

get_execution_time

}

main
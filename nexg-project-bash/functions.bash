log() {
local message="$1"
local exit_code="$2"
local timestamp="$(date '+%b %d %H:%M:%S')"
local log_entry=""

        if [ -n "$exit_code" ] && [ "$exit_code" -ne 0 ]; then
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: ($(whoami)) [ERROR] Exit code ${exit_code}: ${message}"
        elif [ -n "$exit_code" ] && [ "$exit_code" -eq 0 ]; then        
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: ($(whoami)) [SUCCESS] Exit code ${exit_code}: ${message}"
        else                                                            
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: ($(whoami)) [INFO] ${message}"
        fi

echo -e "$log_entry"
}

check_command() {
local command="$1"

command -v "$command" > /dev/null

cmd_exit_code="$?"

if [ "$cmd_exit_code" -ne 0 ]; then
	log "Command $command doesn't exist"
	exit
fi
}

check_host() {
local host="$1"

log "Checking SSH on the VM $host."
nc -z -w 2 "$host" "$ssh_port"
exit_code="$?"

	if [ "$exit_code" -ne 0 ]; then
		log "Could not connect to the VM $host through SSH." "$exit_code"
		log "Sending SMS to $to..."
		send_message "$host" sshd Down Emergency		
		return "$exit_code"
	fi
	
echo "$host" >&3
log "VM $host is up and running."
}

check_ssh() {
local -n hosts="$1"

exec 3> "$available_hosts"

for host in "${hosts[@]}"; do
	check_host "$host"	&	
done	
	wait
}

run_ssh_command() {
command="$1"

ssh -o ConnectTimeout="$waiting" -q -T -l "$user" "$host" -p "$ssh_port" "$command"
}

check_socket_service() {
local host="$1"
local service="$2"
local socket="$3"
local check_estab="$4"

log "Checking $service and $socket on the VM $host."
run_ssh_command "sudo pgrep -x $service &> /dev/null && sudo ss -lntp | grep -wq $service"
service_exit_code="$?"

if [ "$service_exit_code" -eq 0 ]; then
	if "$check_estab"; then
		log "Checking establised count of $service on the VM $host."
		estab_count="$(run_ssh_command "sudo ss -ntp | grep -c "$service" ")"
	
		if [ "$estab_count" -lt "$estab_count_limit" ]; then
			log "Established connection of $service is below $estab_count_limit on the VM $host." "$ERROR"
			log "Sending SMS to $to..."
			send_message "$host" "$service" "Below $estab_count_limit" Warning
			echo down > "$service_stat_loc/$(basename $0_${socket}_${host}).lock"
			return 1
		elif [ -e "$service_stat_loc/$(basename $0_${socket}_${host}).lock" ]; then
			log "Established connection of $service is above $estab_count_limit on the VM $host." "$SUCCESS"
			log "Sending SMS to $to..."
			send_message "$host" "$service" "Above $estab_count_limit" None
			log "Removing the lock file."
			rm -fv "$service_stat_loc/$(basename $0_${socket}_${host}).lock"
			return 0			
		fi
		
		log "Service $service count is greater than $estab_count_limit on the VM $host."	
	fi
else
	log "Service $service is down on the VM $host" "$ERROR"
	log "Sending SMS to $to..."
	send_message "$host" "$service" Down Emergency
	echo down > "$service_stat_loc/$(basename $0_${service}_${host}).lock"
	return 1
fi

if [ -e "$service_stat_loc/$(basename $0_${service}_${host}).lock" ]; then
	log "Service $service previous state found."
	send_message "$host" "$service" Up None
	log "Removing the lock file."
	rm -fv "$service_stat_loc/$(basename $0_${service}_${host}).lock"
fi

log "Service $service is up and running on the VM $host."
}

check_host_services() {
    local host="$1"
	local -n local_services="$2"
	local check_estab="$3"

    for service in "${!local_services[@]}"; do
        check_socket_service "$host" "$service" "${local_services[$service]}" "$check_estab" &
    done
    wait
}

check_service_estab() {
local -n hosts="$1"
local -n int_service="$2"
local check_estab="$3"

for host in "${hosts[@]}"; do	
		check_host_services "$host" int_service "$check_estab" &
done
	wait
}

send_message() {
local service="$2"
local message="Dear TechOps,

Service: $service
Host: $1
Severity level: $4
State: $3
Date/Time: $(date "+%d %b %Y %H:%M")

Thanks and Regards,
nexG Platforms."

response="$(curl -L -s -G \
--data-urlencode "username=$username" \
--data-urlencode "password=$password" \
--data-urlencode "from=$from" \
--data-urlencode "to=$to" \
--data-urlencode "indiaDltContentTemplateId=$indiaDltContentTemplateId" \
--data-urlencode "indiaDltPrincipalEntityId=$indiaDltPrincipalEntityId" \
--data-urlencode "text=$message" \
"$api_url"
)"

log "SMS API Response."
echo "$response" | jq
}

get_execution_time() {
    duration="$SECONDS"
    hours=$((duration / 3600))
    minutes=$((duration % 3600 / 60))
    seconds=$((duration % 60))
    echo -e "\n$(basename $0): execution time: ${hours} hour(s) ${minutes} minute(s) ${seconds} second(s)"
}

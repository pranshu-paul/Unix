# Standalone Function to log each event
log() {
local message="$1"
local exit_code="$2"
local timestamp="$(date '+%b %d %H:%M:%S')"
local log_entry=""

		# Check if the exit code is not empty and not zero.
        if [ -n "$exit_code" ] && [ "$exit_code" -ne 0 ]; then
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: ($(whoami)) [ERROR] Exit code ${exit_code}: ${message}"
		# Check if the exit code is not empty and zero.				
        elif [ -n "$exit_code" ] && [ "$exit_code" -eq 0 ]; then        
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: ($(whoami)) [SUCCESS] Exit code ${exit_code}: ${message}"
		# Default case: if the exit code empty.
        else                                                            
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: ($(whoami)) [INFO] ${message}"
        fi

echo -e "$log_entry"
}

# Standalone Function to check a command existence
check_command() {
local command="$1"

# Check the command.
command -v "$command" > /dev/null

cmd_exit_code="$?"

if [ "$cmd_exit_code" -ne 0 ]; then
	log "Command $command doesn't exist"
	exit
fi
}

# Standalone function to check SSH on VM
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

# Worker function to check each host parallely
check_ssh() {
local -n hosts="$1"

# Open a file descriptor.
exec 3> "$available_hosts"

# Loop though the reference of the hosts array.
for host in "${hosts[@]}"; do

	check_host "$host"	&
	
done
	
	wait
}

run_ssh_command() {
command="$1"

# Run the command through SSH with the following options.
# Connection timeout, quiet, username, ip adress, port, command
ssh -o ConnectTimeout="$waiting" -q -T -l "$user" "$host" -p "$ssh_port" "$command"
}

# Standalone function to check the availability of the service
check_socket_service() {
local host="$1"
local service="$2"
local socket="$3"
local check_estab="$4"

log "Checking $service on the VM $host."
run_ssh_command "sudo pgrep -x $service &> /dev/null"
service_exit_code="$?"

log "Checking $socket on the VM $host."
run_ssh_command "sudo ss -lntp | grep -wq $service"
socket_exit_code="$?"

# Check if the service or socket is not equal to zero.
if [ "$service_exit_code" -eq 0 ] && [ "$socket_exit_code" -eq 0 ]; then

	if "$check_estab"; then
		log "Checking establised count $service on the VM $host."
		estab_count="$(run_ssh_command "sudo ss -ntp | grep "$service" | wc -l")"
	
		if [ "$estab_count" -lt "$estab_count_limit" ]; then
			log "Established connection of $service is below $estab_count_limit on the VM $host." "$ERROR"
			log "Sending SMS to $to..."
			send_message "$host" "$service" "Below $estab_count_limit" Emergency
			return 1
		fi
		
		log "Service $service count is greater than $estab_count_limit on the VM $host."	
	fi
	
elif [ "$service_exit_code" -ne 0 ] || [ "$socket_exit_code" -ne 0 ]; then
	log "Service $service is down on the VM $host" "$ERROR"
	log "Sending SMS to $to..."
	send_message "$host" "$service" Down Emergency
	return 1
fi

log "Service $service is up and running on the VM $host."
}

# Worker function to check multiple services with their socket
check_service_estab() {
local -n hosts="$1"
local -n services="$2"
local check_estab="$3"

# Loop through each host.
for host in "${hosts[@]}"; do

	# Loop though each service on the host in the outer loop.
	for service in "${!services[@]}"; do
	
		check_socket_service "$host" "$service" "${services[$service]}"	"$check_estab" &
		
	done
	
done

	wait
}

# Standalone function to send SMS
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
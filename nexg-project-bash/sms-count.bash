#!/bin/bash

# Check the highest SMS count of the day
# On DB node: sar -pd | grep app01 | sort -n -k 11 | tail -1
# grep -r 'Sent SMS Count' | sort -n -k 13 | tail -2
# Process level: pidstat -d -p 3593049 1 # Required root prvileges

source /home/pranshu/scripts/functions

declare -a hosts=(
'172.19.8.166'
'172.19.8.167'
)

# SMS configuration
api_url="https://api2.nexgplatforms.com/sms/1/text/query"
username="NexGAlrT"
password="Happy@1234"
from="NXGART"
to="919873514389"
indiaDltContentTemplateId="1207171507167956290"
indiaDltPrincipalEntityId="1201164455577917424"

# Global directives
ERROR=1

waiting=5
_log_file=/app01/kannel/bbaccess.log
keyword=Sent

log_dir=/home/$(whoami)/scripts/logs
log_file="${log_dir}/$(basename $0)_$(date +%d_%b_%H%M%S).log"

exec &> >(tee -a "$log_file")

get_sent_sms() {
	local host="$1"

	sms_count=$(ssh -q "$host" "timeout $waiting tail -n 0 -f $_log_file" | grep --line-buffered -owc "$keyword")
	log "Host: $host Sent SMS Count: $sms_count"
	
	if [ "$sms_count" -eq 0 ]; then
		log "SMS count is 0 on the VM $host" $ERROR
		send_message "$host" SMS "SMS Count is 0" Emergency
	fi
}

check_sent_sms() {
	local -n bearerbox_hosts="$1"
	
	for host in "${hosts[@]}"; do
		get_sent_sms "$host" &
	done
	
	wait
}

check_sent_sms hosts

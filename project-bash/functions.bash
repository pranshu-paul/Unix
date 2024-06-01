check_port() {
local host=$1
local port=$2
ssh -q -T -l "$user" "$host" -p "$ssh_port" << EOF
ss -lnt | grep -q ":$port"
#echo \$?
EOF
}

check_estab() {
local host=$1
local service=$2
ssh -q -T -l "$user" "$host" -p "$ssh_port" << EOF
sudo ss -ntp | grep "$service" | wc -l
EOF
}

check_service() {
local host=$1
local service=$2
ssh -q -T -l "$user" "$host" -p "$ssh_port" << EOF
pgrep -x "$service" &> /dev/null
#echo \$?
EOF
}

check_command() {
command -v $1 > /dev/null || { log "Command $1 doesn't exist"; exit 1; }
}

check_host() {
local host=$1
nc -z -w 2 "$host" "$ssh_port"
}

log() {
local message="$1"
local exit_code="$2"
local timestamp="$(date '+%b %d %H:%M:%S')"
local log_entry=""

        if [ -n "$exit_code" ] && [ "$exit_code" -ne 0 ]; then
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: [ERROR] Exit code ${exit_code}: ${message}"
        elif [ -n "$exit_code" ] && [ "$exit_code" -eq 0 ]; then
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: [SUCCESS] Exit code ${exit_code}: ${message}"
        else
                log_entry="${timestamp} $(hostname) $(basename $0)[$$]: [INFO] ${message}"
        fi

echo -e "$log_entry"
}

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
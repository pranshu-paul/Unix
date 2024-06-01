#!/bin/bash

source /home/$(whoami)/scripts/functions
source /home/$(whoami)/scripts/variables

# Global directives.
ERROR=1

log_dir=/home/$(whoami)/scripts/logs
log_file="${log_dir}/$(basename $0)_$(date +%d_%b_%H%M%S).log"
service_stat_loc=/home/$(whoami)/scripts/locks

# exec &>> "$log_file"

mkdir -pv "$log_dir"

check_command nc
check_command jq

for host in "${hosts[@]}"; do

        log "Checking SSH connectivity on host $host."
        check_host "$host"
        exit_code=$?

        if [ "$exit_code" -ne 0 ]; then
                log "Could not connect to the host $host through SSH." "$exit_code"
                log "Sending SMS to $to..."
                send_message "$host" sshd Down Emergency
                log "Message sent" $?
                continue
        fi

        for service in "${!services[@]}"; do
                log "Checking the service $service on the host $host."
                service_exit_code=$(check_service "$host" "$service"; echo $?)

                log "Checking the port ${services[$service]} on the host $host."
                port_exit_code=$(check_port "$host" "${services[$service]}"; echo $?)

                if [ "$service_exit_code" -ne 0 ] || [ "$port_exit_code" -ne 0 ]; then
                        log "Service $service is down on the host $host." $ERROR
                        log "Sending SMS to $to..."
                        echo down > $service_stat_loc/$(basename $0_${service}_${host}).lock
                        send_message "$host" "$service" Down Emergency
                        log "Message sent" $?
                elif [ -e $service_stat_loc/$(basename $0_${service}_${host}).lock ]; then
                        log "Service $service previous state found."
                        send_message "$host" "$service" Up None
                        log "Removing the lock file."
                        rm -fv $service_stat_loc/$(basename $0_${service}_${host}).lock
                fi

                log "Checking the established count of the port ${services[$service]} on the host $host."
                estab_exit_code=$(check_estab "$host" "$service" | tail -1)

                if [ "$estab_exit_code" -lt 100 ] && [ "$service_exit_code" -eq 0 ] && [ "$port_exit_code" -eq 0 ]; then
                        log "Established count of the service $service is zero on the host $host." $ERROR
                        log "Sending SMS to $to..."
                        echo down > $service_stat_loc/$(basename $0_${services[$service]}_${host}).lock
                        send_message "$host" "$service" Low Warning
                        log "Message sent" $?
                elif [ -e $service_stat_loc/$(basename $0_${services[$service]}_${host}).lock ]; then
                        log "Service $service previous state found."
                        send_message "$host" "$service" Up None
                        log "Removing the lock file."
                        rm -fv $service_stat_loc/$(basename $0_${services[$service]}_${host}).lock
                fi

        done
done

find "${log_dir}" -name "$(basename $0)_*.log" -mtime +2 -type f -ls -delete
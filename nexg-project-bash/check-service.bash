#!/bin/bash

# Path to the functions and variables file.
source /home/pranshu/scripts/functions
source /home/pranshu/scripts/variables
source /home/pranshu/scripts/constants

log_file="${log_dir}/$(basename $0)_$(date +%d_%b_%H%M%S).log"
available_hosts="/tmp/$(basename $0)_available_hosts_$$"

mkdir -pv "$log_dir"
mkdir -pv "$service_stat_loc"

exec &> >(tee -a "$log_file")

main() {
check_command nc
check_command jq

check_ssh ksmpp_hosts
exec 3< "$available_hosts"
mapfile -t working_ksmpp_hosts <&3
check_service_estab working_ksmpp_hosts srv01 true
: > /proc/self/fd/3
exec 3<&-
rm -f "$available_hosts"

check_ssh bear_sql
exec 3< "$available_hosts"
mapfile -t working_bear_sql <&3
check_service_estab working_bear_sql srv02 true
check_service_estab working_bear_sql srv03 false
: > /proc/self/fd/3
exec 3<&-
rm -f "$available_hosts"

check_ssh kannel
exec 3< "$available_hosts"
mapfile -t working_kannel <&3
check_service_estab working_kannel srv02 false
check_service_estab working_kannel srv03 false
: > /proc/self/fd/3
exec 3<&-
rm -f "$available_hosts"

check_ssh redis
exec 3< "$available_hosts"
mapfile -t working_redis <&3
check_service_estab working_redis srv04 false
: > /proc/self/fd/3
exec 3<&-
rm -f "$available_hosts"

check_ssh mysql
exec 3< "$available_hosts"
mapfile -t working_mysql <&3
check_service_estab working_mysql srv05 false
: > /proc/self/fd/3
exec 3<&-
rm -f "$available_hosts"

get_execution_time
}

main

user=pranshu
ssh_port=22
waiting=2

declare -a ksmpp_hosts=(
"172.19.8.151"
"172.19.8.152"
)

declare -a bear_sql=(
"172.19.8.166"
"172.19.8.167"
)

declare -A srv01=( 
["ksmppd"]=2777
)

declare -a kannel=(
"172.19.8.168"
)

declare -A srv02=(
["bearerbox"]=13001
)

declare -A srv03=( 
["sqlbox"]=13002
)

estab_count_limit=100

log_dir=/home/pranshu/scripts/logs
service_stat_loc=/home/pranshu/scripts/locks
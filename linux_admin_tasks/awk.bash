awk '{$1=""}1' # Eliminates 1st row in output.

ldd $(which sshd) | awk '{$4=""}1' | grep -E '^libp[a-m]+'


# Prints the string if matches the input.
echo manager | awk '/manager/ {print}'


# Print the first and third column sperated by :
awk -F : '{print $1,$3}' /etc/passw
awk -F: '{print $1 " home at " $6}' /etc/passwd

# To print a specifc row rnage of a particular column.
df -h | awk 'NR==1, NR==10 {print $4}'


# Print a specific column with row number.
df -h | awk '{print NR " - " $4 }'


df -h | awk '{ if (length($0) > max) max = length($0) } END { print max }'

# Count the number of lines
df -h | awk 'END { print NR }'

# To a columns every occurance.
echo -e "Hello Tom\nPranshu lee" | awk '{$2="Paul"; print $0}'

# To print some text or headings.
awk 'BEGIN {print "Report Title"}'


# To add a header and footer on the command output.
df -h | awk 'BEGIN {print "The File Contents:"} {print $0} END {print "File footer"}'


# Change a field seperator with an output field seperator.
awk 'BEGIN{FS=":"; OFS=" = "} {print $1,$6,$7}' /etc/passwd

df -h | awk 'BEGIN{FS="\n"; RS=" "} {print $1,$2,$4}'

# To print environment variables.
awk 'BEGIN{print ENVIRON["PATH"]}'


# To print only the first column and the last column.
awk 'BEGIN{FS=":"; OFS=":"} {print $1,$NF}' /etc/passwd


awk 'BEGIN{test="Welcome to LikeGeeks website" print test}'

awk 'BEGIN{x = 100 * 100 printf "The result is: %e\n", x}'

awk "BEGIN {printf \"%.2f\", ($total_non_idle / $total_time) * 100}"

df -h --total | awk 'NR == 1; END{print}'

history | awk '{$1=""}'1

awk -F: '($3 == "0") {print}' /etc/passwd

echo | openssl s_client -connect <hostname>:443 2> /dev/null | \
awk '/-----BEGIN/,/END CERTIFICATE-----/' | \
openssl x509 -noout -enddate


df -P | awk 'NR>1'|awk '{x+=$2}{y+=$3}END{print y*100/x}'

df -P | awk 'NR>1' | awk '{print $6,$5}'

free -b | awk '/Mem:|cache:/ {print $2,$3}' | sed 'N;s/\n/ /' | awk '{if($4!=""){print ($4*100)/$1}else{print ($2*100)/$1}}'

vmstat 1 3 | awk '{for (i=0;i<=NF;i++) if ($i == "id") cmd=i;} {print 100-$cmd}' | tail -1
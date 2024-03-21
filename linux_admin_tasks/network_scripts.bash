#!/bin/bash

# Description: To check which ports are open on the server.

# For a set of ports: ({25,80,443})
# For ports range: ({1..1024})

host="google.com"
ports=({1..5})
timeout=2

for port in "${ports[@]}"; do
    if ncat -zv -w "$timeout" "$host" "$port" &> /dev/null; then
        service=$(getent services "$port/tcp" | awk '{print $1}')
        echo "Port $port is open! Service: $service"
    else
        echo "Port $port is closed."
    fi
done

# For Ubuntu and Solaris.
nc -zv -w 2 google.com {80,443}
nc -zv -w 2 google.com {80..443}


############################
#!/bin/bash

# Description: To trace the route to a server.

target_host="$1"

if [ -z "$target_host" ]; then
    echo "Usage: $0 <target_host>"
    exit 1
fi

echo "Running mtr to $target_host..."

mtr -c 10 --report "$target_host"


#################################################

# To check on which Protocol the interface is: TCP or UDP

tcpdump -i ens3 -n -c 5 -v | grep -o -E 'UDP|TCP'



# To create a socket and start the service as a request comes.
while true; do
	netcat -l -w 1 80
	service nginx start
	break
done

ncat -l -p 80 --sh-exec "systemctl start nginx"

ncat -l -p 80 --exec "/usr/bin/systemctl start nginx"
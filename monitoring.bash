#!/bin/bash

file=/root/loop

keyword=hello

tail -n 0 -f ${file} | grep --line-buffered -w ${keyword} | while read line
do
	echo "SMS command here"
done

# ============================================================================== #

#!/bin/bash

file=/root/loop
keyword=failed
threshold=5

count=0

while true
do
	tail -n 0 -f ${file} | grep --line-buffered -w ${keyword} | while read line
	do
		echo "SMS command here"
		
		((count++))
		
		if [ ${count} -eq ${threshold} ]
		then
			break
		fi
		
	done
	
	sleep 30
done

# ============================================================================== #

#!/bin/bash

while true
do
	if ! ss -4lnt | grep -q :80; then
		echo "SMS command here"
	fi
	sleep 2
done

kill -19 <ppid> # To pause the process.

kill -18 <ppid> # To continue the process.
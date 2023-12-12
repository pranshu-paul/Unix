dnf -y install thunderbird xdotool

xdotool mousemove 45 45

xdotool click 1

xdotool key --window $(xdotool search --class thunderbird | tail -1) key ctrl+Return

#####################
#!/bin/bash

port=1
subject=${1}
from=${2}
to=${3}
message=${4}

if [[ "$#" -lt 4 ]]; then
	exit
fi

if [ ! -e /tmp/.X11-unix/X${port} ]; then
	vncserver :${port}
fi

export DISPLAY=:${port}

if pgrep thunderbird; then
	pkill thunderbird &
	sleep 2
fi

command="thunderbird -compose \"subject='${subject}',from='${from}',to='${to}',body='${message}'\""

eval ${command} &

sleep 7

xdotool key --window $(xdotool search --class thunderbird | tail -1) key ctrl+Return

sleep 5
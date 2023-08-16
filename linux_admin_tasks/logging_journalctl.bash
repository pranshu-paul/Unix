# Package = systemd
journalctl - Query the systemd journal

# To show all the collected logs.
journalctl

# To actively follow log (like tail -f).
journalctl -f

# To show only kernel messages.
journalctl -k

# Shows one line messages, newest first.
journalctl -o short -r

# List number of boots.
journalctl -r --list-boots

# Search for the exact string.
journalctl -r -t

# To check logs for sshd.
journalctl -f -t sshd

# To check journals disk usage.
journalctl --disk-usage

# To display follow log of specific service.
journalctl -f -u ssh

# To filter by specific User ID e.g., user id 1000.
journalctl _UID=1000

# To check logs made by an executable.
journalctl -r $(which sshd)

# To check n number of line.
journalctl -n N

# To check priority wise.
# ebug (7), info (6),
# notice (5), warning (4), err (3), crit (2), alert (1), and emerg (0).
journalctl -p 3

# To check logs from specific date.
journalctl -S "2020-10-30 18:17:16"


# To search for a specific command on a specific date.
journalctl -b --since="2023-08-15 00:00:00" --until="2023-08-15 23:59:59" | grep "COMMAND=ls"

# To create logs while automating.
logger -t TAG "MESSAGE"

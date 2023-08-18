# Package = systemd
journalctl - Query the systemd journal

# To show all the collected logs.
journalctl

# To actively follow log (like tail -f).
journalctl -f

# To show only kernel messages (same as dmesg).
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

# To filter by a specific User ID e.g., user id 1000.
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
logger -t <application/service_name> "Removing the files <file_name>. USER=oracle; PWD=<path>; COMMAND=/bin/rm -fv <file_name>"

# To broadcast a message.
wall <message>

# To send messages to a specific user.
echo <message> | write <username>

echo <message> | write <username> <tty>

# The below message will be displayed to oracle only, and wherever the user is logged in.
echo 'The system is going to reboot' | write oracle

# For physical console: tty<n>; For virtual consoles/SSH connections: pts/<n>
echo 'The system is going to reboot' | write oracle pts/1
echo 'The system is going to reboot' | write oracle tty1

######################################
# Auditing in Red Hat Enterprise Linux

# To install auditctl.
yum -y install audit

# To enable auditctl.
systemctl enable --now auditd

# List audit rules.
auditctl -l

# To report the status of audit system.
auditctl -s

# To delete all rules.
auditctl -D

# To define a file system rule, use the following syntax.
# auditctl -w PATH_TO_FILE -p PERMISSIONS -k KEY_NAME

# permission types.
# r — read access to a file or a directory.
# w — write access to a file or a directory.
# x — execute access to a file or a directory.
# a — change in the file's or directory's attribute.

#  -k KEY_NAME can be a arbitrary name.# To install aureport.
yum -y install audit

# To check audit report.
aureport

# To install ausearch.	
# see auditctl
yum -y install audit

# To search from defined auditing rules from "auditctl".
ausearch -k KEY_STRING
# To install crontab.
yum -y install cronie

# crontab format
* * * * *  command_to_execute
- - - - -
| | | | |
| | | | +- day of week (0 - 7) (where sunday is 0 and 7)
| | | +--- month (1 - 12)
| | +----- day (1 - 31)
| +------- hour (0 - 23)
+--------- minute (0 - 59)


# To install at.
yum -y install at

# To schedule a one time task.
# Options for timing are.
# now | midnight | noon | teatime
# at now | at midnight etc.

# For example.
	at 14:30
# Output.
at>date
at>hostnamectl
at>Ctrl-d

# To list pending jobs.
atq

# Sample output of atq.
4       Fri Aug 27 21:56:00 2021 a root
# 4 is the job id.

# To remove a job (use id from atq)
atrm 4
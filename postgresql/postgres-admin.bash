# Required environment variables.
LD_LIBRARY_PATH=/usr/lib64

# PATH

# Default data directory. Variable is PGDATA
# Standard modes, for single node: 700 for directories and 600 for files.
# For cluster: 750 for directories and 640 for files.
/var/lib/pgsql


# Required kernal parameters.
# Shared Memory Available, Shared Memory Max.
# Parameters can be added in /etc/sysctl.d/postgresql.conf
kern.ipc.shmall=32768
kern.ipc.shmmax=134217728
vm.overcommit_memory=2
vm.nr_hugepages=3170

# After adding the kernel parameters.
# A system reboot is required.
systemctl reboot

# The below variables prevent "postmaster" from getting killed by kernal when the system is low on memory.
# These variables can also be set in the "postgresql.service" unit file.
# We could set the out-of-memory (OOM) score.
echo -1000 > /proc/self/oom_score_adj
export PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj
export PG_OOM_ADJUST_VALUE=0


# In the file /etc/systemd/logind.conf
# "RemoveIPC=no" must be set to "no"
# Otherwise postgres will not properly.

# If creating the "postgres" user manually.
# Make sure to use the below command.
useradd -r -m /var/lib/pgsql postgres






































\c -- connect
\l -- lists databases
\d -- lists all the objects
\d <table_name> -- lists details about a table
\dt -- lists all the tables 
\q -- quit


Datatypes:
VARCHAR(string-length)
INT
SERIAL
DATE
NUMERIC(4, 1); -- Can have four decimal places to the right side.
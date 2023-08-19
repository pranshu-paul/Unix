# POTGRESQL STRUCTURE AND REQUIREMENTS

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


# To enforce password while logging in.
# Change the authentication method to "md5" from "ident" or "blank".
# In the file "/var/lib/pgsql/data/pg_hba.conf".
# After making any changes, run the below command.
pg_ctl reload

# In case you forget the password.
# Just revert the auth method.


# User Management.
create user <username> with password '<password>';
create user <username> with encrypted password '<password>';

alter user <username> password '<password>';

create database <database> owner <username>;

alter database <database> owner to <username>;

# For postgres user only.
\password

grant all privileges on database <database> to <username>;


# General administrative commands.
\c -- connect
\l -- lists databases
\d -- lists all the objects
\d <table_name> -- lists details about a table
\dt -- lists all the tables 
\q -- quit

\dn -- lists the available schemas
\df -- lists functions
\du -- lists users


SELECT version(); # Shows the postgresql version.

\i <filename> -- runs a SQL script from the prompt.

\? -- to get help

\h <sql_command> -- to get help about a particular SQL command
\h alter table
\h 


# psql commands
psql -f <postgres_commands> -- # Reads commands from the file.
psql -h <ip_address> -p <port> -U <username> -W # -- The "W" flag is to prompt for the password.
psql -c '<sql_query>' <database> # Executes a single query on the given database name.


# pg_ctl
pg_ctl start # Starts postgres
pg_ctl stop # Stops postgres
pg_ctl reload # Reloads postgres

# Shows the all active processes.
select * from pg_stat_activity;

# Gives the statistics about the "bgwriter" process.
select * from pg_stat_bgwriter;

# Gives a briefing about the database.
pg_controldata $PGDATA

Datatypes:
varchar(string-length)
int
serial
date
numeric(4, 1); -- Can have four decimal places to the right side.
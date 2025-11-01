yes | pkg install postgresql14-server postgresql14-client

sysrc postgresql_enable="YES"

/usr/local/etc/rc.d/postgresql initdb

service postgresql start

sockstat -46 | grep 5432

# /var/db/postgres/data14/postgresql.conf
password_encryption = scram-sha-256
log_connections = yes
log_destination = 'syslog'
search_path = '"$user", public'
shared_buffers = 128MB

# At line no. 96 /var/db/postgres/data14/pg_hba.conf
host all all 127.0.0.1/32 scram-sha-256

postgres=# \conninfo

psql -U mydbuser -h 127.0.0.1 -d postgres

# Configuration TLS encryption on PostgreSQL server.
# Public and private key have to be named server.crt and server.key
openssl req \
-new \
-x509 \
-days 365 \
-nodes \
-text \
-out server.crt \
-keyout server.key \
-subj "/CN=paulpranshu.xyz"

cp -v server.key /var/db/postgres/data14
cp -v server.crt /var/db/postgres/data14


chown -v postgres:postgres /var/db/postgres/data14/server.key
chown -v postgres:postgres /var/db/postgres/data14/server.crt

chmod -v 0400 /var/db/postgres/data14/server.key

# Change the below line in /var/db/postgres/data14/postgresql.conf
password_encryption = scram-sha-256
ssl=on

# Change the client authentication method in /var/db/postgres/data14/pg_hba.conf
hostssl all all 127.0.0.1/32 scram-sha-256

service postgresql restart


####################################################################################################

pg_dump hr > hr_backup.sql


# Backup the complete database.
pg_dumpall > pg.sql

# To dump a database over a network.
pg_dump -h host1 dbname | psql -h host2 dbname

# To catch the errors during the restore.
psql --set ON_ERROR_STOP=on dbname < dumpfile

# Creating a tar of the $PGDATA folder
tar -cf backup_$(date "+%Y-%m-%d").tar /var/db/postgres/data14


#####################################################################################################
/var/db/postgres/data14/postgresql.conf
wal_level = replica
archive_mode = on
archive_command = 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'

# To create a complete backup.
pg_basebackup -D /bkp -Fp

# To backup the whole directory compressed.
pg_basebackup -D /pg_backup -Ft -z


# Restoring the backup.
service postgresql stop

show archive_mode;
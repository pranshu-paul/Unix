pg_dump --format=custom students > students.dump

# To dump all the database in a single command.
pg_dumpall > dump.sql

# To dump a single database in the custom postgres format.
pg_dump --username=postgres students --host=127.0.0.1 --port=5432 --format=custom --file=students.dump
pg_dump students --format=custom --file=students.dump

# To backup all the schemas only.
pg_dumpall --schema-only > schema.sql

# To transfer data in a different database.
pg_dumpall --clean --column-inserts --host=127.0.0.1 --port=5432 --file=insert.sql

# Postgres environment variables.
# PGHOST
# PGPORT
# PGUSER

pg_restore --list students.dump

pg_restore --verbose --clean --schema students --dbname students students.dump

-- Create a user for hr schema.
create user pranshu with password 'Mysql#459';

# To change the password.
alter user pranshu password 'Mysql#459';

-- Grant the necessary privileges to the user.
alter role pranshu createdb replication;

-- Change the default schema of the user.
alter role pranshu set search_path = students;

-- Create a database and give the authority the user created.
create database students owner pranshu;

-- From pranshu user.
select current_user;

-- Verify the current schema path, it should return the schema name created earlier.
show search_path;

-- Create a schema. Give the name as provided above in the "search_path".
create schema students authorization pranshu;

-- Run the SQL script within the user.
\i /var/lib/pgsql/hr.sql
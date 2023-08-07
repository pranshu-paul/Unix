# Backingup the database:
pg_dump -- Creates a dump of the database.

--clean                  clean (drop) database objects before recreating
--create                 include commands to create database in dump
--inserts                dump data as INSERT commands, rather than COPY

pg_dump --clean --create --inserts --username=<username> <database> > <database>.sql

pg_dump --clean --create --inserts --username=freecodecamp students > students.sql
pg_dump --clean --create --inserts --username=freecodecamp mario_database > mario_database.sql

# Restoring the database created earlier
psql -U postgres < students.sql
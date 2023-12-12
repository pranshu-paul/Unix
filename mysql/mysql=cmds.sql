help;

show databases;

create database <db_name>;

drop database <db_name>;

-- Listing databases.
show databases;

-- Listing tables.
show tables;

-- Switiching databases.
use <db_name>;

-- Creating a local user.
create user 'user'@'localhost' identifued by 'password123';

-- A public user.
create user 'user'@'%' identifued by 'password123';

alter user 'user'@'localhost' identified by 'password456';

-- Listing users.
select user, host from mysql.user;

-- Drop a user.
drop user 'user'@'localhost'

-- Granting privileges on a specific database.
grant all privileges on <database>.* to 'user'@'%';

-- Granting privileges on all databases.
grant all privileges on *.* to 'user'@'%';

-- Grant specific privilege on a specific table in a database.
grant select, insert, delete on employee.department to 'user'@'%';

-- Listing grants of a user.
show grants for 'user'@'%';

-- Listing indexes on a table.
show indexes from <table_name>;

-- Creating an index on a column of a table.
create index <index_name> on table_name(column_name);

-- Dropping an index.
alter table <table_name> drop index <index_name>;

-- Listing processes.
show processlist;
show processlist where user = 'your_username';
select * from information_schema.processlist;


-- Creating a backup as a SQL script.
mysqldumpt -u root -p employee > emp_backup.sql

-- Restoring a database.
mysql -u root -p employee < emp_backup.sql



-- Getting session variables.
show session variables like '%isolation%';
show session variables like '%autocommit%';

set session transaction isolation level read-uncommitted;
set session transaction isolation level searializable;


-- Locking a table.
lock table <table_name> write;

-- Unlocking the tables.
unlock tables;

-- Retrieving table level locks.
select * from performance_schema.data_locks;

-- Applying row-level locks.
start transaction;
select * from employees where employee_id = 101 for update;
update employees set salary = salary + 1000 where employee_id = 101;
commit;

-- Retrieving row level locks.
select * from performance_schema.table_io_waits_summary_by_index_usage;
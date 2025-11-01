psql --username=freecodecamp --dbname=postgres

\l -- list databases

\c -- connect databas

\d [table_name] -- display tables
create database bikes;

create table bikes();

alter table <table> add column <col_name> <data_type> <constraint>;

alter table bikes add column bike_id serial primary key;

alter table bikes add column type VARCHAR(50) not null;

alter table <table> add column <col_name> <data_type> <constraint> <default_value>;
alter table bikes add column available boolean not null default true;

alter table customers add column phone varchar(15) unique not null;

alter table rentals add foreign key (customer_id) references customers (customer_id);

alter table rentals add column date_rented date not null default now();

insert into bikes (type, size) values ('Road', 28), ('Road', 29);

insert into bikes (type, size) values ('BMX', 19), ('BMX', 20), ('BMX', 21);

update bikes set available = true where type != 'BMX';

select * from bikes inner join rentals using (bike_id);

select * from bikes inner join rentals using (bike_id) inner join customers using (customer_id);

select * from bikes inner join rentals using (bike_id) inner join customers using (customer_id) where phone = '555-5555' and date_returned is null;

select bike_id, type, size from bikes inner join rentals using (bike_id) inner join customers using (customer_id) where phone = '555-5555' and date_returned is null;

select bike_id, type, size from bikes inner join rentals using (bike_id) inner join customers using (customer_id) where phone = '555-5555' and date_returned is null order by bike_id;

select * from rentals inner join customers using (customer_id) where phone = '555-5555' and bike_id = 1 and date_returned is null;
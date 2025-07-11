# Postgresql SQL commands.

alter table second_table drop column age;
alter table characters add primary key (name);
alter table more_info alter column character_id set not null;
alter table more_info add column character_id add foreign key(character_id) references characters(character_id);
alter table more_info add unique (character_id);
alter table characters drop constraint characters_pkey;
alter table more_info add column more_info_id serial;
alter table more_info add column character_id int references characters(character_id);
alter table more_info add column birthday date;
alter table second_table rename column name to username;
insert into second_table (id, username) values (2, 'Mario');
delete from second_table where username = 'Luigi';
drop table second_table ;
alter database first_database rename to mario_database;
drop database second_databas;
create table characters ();

create table sounds (sound_id serial primary key);
alter table sounds add column filename varchar(40) not null unique;
alter table sounds add column character_id int not null references characters(character_id);
insert into sounds (filename, character_id) values ('its-a-me.wav', 1);

alter table actions add column action varchar(20) unique not null;

alter table character_actions add primary key (character_id, action_id); -- composite key

insert into character_actions (character_id, action_id) values (7, 1), (7, 2), (7, 3); -- multiple values

select * from characters full join more_info on characters.character_id = more_info.character_id;

alter table character_actions add foreign key (action_id) references actions (action_id);

alter table actions add column action varchar(20) unique not null;
insert into characters (name, homeland, favorite_color) values ('Daisy', 'Sarasaland', 'Yellow'), ('Yoshi', 'Dinosaur Land', 'Green') ;
update characters set favorite_color='Orange' where name='Daisy';

SELECT * FROM character_actions FULL JOIN characters ON character_actions.character_id = characters.character_id FULL JOIN actions ON character_actions.action_id = actions.action_id;
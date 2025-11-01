-- Procedure
create or replace procedure add_numbers(a INT, b INT)
language plpgsql
as $$
declare
result INT;
begin
result := a + b;
    RAISE NOTICE 'The result of the addition is %', result;
end; $$;

CALL add_numbers(5, 7);

-- Cursor

create or replace function get_major_id(p_major_id integer)
   returns text as $$
declare 
	 titles text default '';
	 rec_students   record;
	 cur_students cursor for
		 select first_name, last_name
		 from students
		 where students.major_id = p_major_id;  -- Use a different name for the function parameter
begin
   -- open the cursor
   open cur_students;
	
   loop
    -- fetch row into the rec_students
      fetch cur_students into rec_students;
    -- exit when no more row to fetch
      exit when not found;

    -- build the output
      titles := titles || ',' || rec_students.first_name || ' ' || rec_students.last_name;

   end loop;
  
   -- close the cursor
   close cur_students;

   return titles;
end; $$

language plpgsql;
wget https://github.com/PostgREST/postgrest/releases/download/v11.2.0/postgrest-v11.2.0-linux-static-x64.tar.xz

tar xJf postgrest-v11.2.0-linux-static-x64.tar.xz

mkdir -p ~/.local/bin

echo 'PATH=$PATH:$HOME/.local/bin' >> ~/.bash_profile

psql -c "create schema api;"

psql -c "create table api.todos (id serial primary key, done boolean not null default false, task text not null, due timestamptz);"

psql -c "insert into api.todos (task) values ('finish tutorial 0'), ('pat self on back');"

psql -c "create role web_anon nologin;"

psql -c "grant usage on schema api to web_anon;"

psql -c "grant select on api.todos to web_anon;"

psql -c "create role authenticator noinherit login password 'Mysql#459';"

psql -c "grant web_anon to authenticator;"

cat << EOF > tutorial.conf
db-uri = "postgres://authenticator:password123@127.0.0.1:5432/postgres"
db-schemas = "api"
db-anon-role = "web_anon"
jwt-secret = "EZQbwkyoosFkVj5h4ntSFHWVsTwEz7pD"
db-pre-request = "auth.check_token"
EOF

postgrest tutorial.conf

curl http://localhost:3000/todos

# Method: -X <HTTP methods>
# Header: -H <MIME to send>
# Body: -d <actual data>
curl http://localhost:3000/todos -X POST \
-H "Content-Type: application/json" \
-d '{"task": "do bad thing"}'


	 
psql -c "create role todo_user nologin;"
psql -c "grant todo_user to authenticator;"
psql -c "grant usage on schema api to todo_user;"
psql -c "grant all on api.todos to todo_user;"
psql -c "grant usage, select on sequence api.todos_id_seq to todo_user;"


# Generate a password.
export LC_CTYPE=C
< /dev/urandom tr -dc A-Za-z0-9 | head -c32


export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.SXzV_IavvkZkHIc8nXSjBT_Bt8usT_WdjAt5JpVnUEo"

curl http://localhost:3000/todos -X POST \
-H "Authorization: Bearer $TOKEN"   \
-H "Content-Type: application/json" \
-d '{"task": "learn how to auth"}' | jq


curl http://localhost:3000/todos -X PATCH \
-H "Authorization: Bearer $TOKEN"    \
-H "Content-Type: application/json"  \
-d '{"done": true}'


# To get the epoch value from postgres.
select extract(epoch from now() + '5 minutes'::interval) :: integer;

# New token with expiration time.
export NEW_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZXhwIjoxNjk1NDY0NDAwfQ.QAXw_gAeTNsrXbTS5yGVunMBWffk8hw85it6fZcpa-0"


export WAYWARD_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIiwiZW1haWwiOiJkaXNncnVudGxlZEBteWNvbXBhbnkuY29tIn0.eO4o_VtkGXDw_4BKkcJ2ZX5ZbAv-amlJiAMFqIGczIM"

# Creating a user for API testing.
create schema auth;
grant usage on schema auth to web_anon, todo_user;

create or replace function auth.check_token() returns void
  language plpgsql
  as $$
begin
  if current_setting('request.jwt.claims', true)::json->>'email' =
     'disgruntled@mycompany.com' then
    raise insufficient_privilege
      using hint = 'Nope, we are on to you';
  end if;
end
$$;
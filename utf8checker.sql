begin;

create schema utf8checker;
set search_path = utf8checker;

create or replace function utf8_report_error (in toid oid, in str bytea) 
returns boolean
as $$
begin
  raise notice 'UTF8 error: table %: row %',
               textin(regclassout(toid)),
               encode(str,'escape');
  return true;
end;
$$
language plpgsql;


create or replace function utf8chk (bytea, oid)
returns boolean
as $$
   select case when utf8hex_valid(encode($1,'hex'))
               then false
               else utf8_report_error($2,$1)
          end
$$
immutable
language sql
;


create or replace function utf8hex_valid (text)
returns boolean
as $$
   select $1 ~ $r$(?x)
                  ^(?:(?:[0-7][0-9a-f])
                     |(?:(?:c[2-9a-f]|d[0-9a-f])
        	|e0[ab][0-9a-f]
        	|ed[89][0-9a-f]
	|(?:(?:e[1-9abcef])
                           |f0[9ab][0-9a-f]
   	|f[1-3][89ab][0-9a-f]
   	|f48[0-9a-f]
  	)[89ab][0-9a-f]
       		)[89ab][0-9a-f]
    	)*$
	$r$;
$$ 
immutable 
language sql
;

commit;

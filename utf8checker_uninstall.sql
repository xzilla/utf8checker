begin;
set search_path = utf8checker;
drop function utf8_report_error (in toid oid, in str bytea); 
drop function utf8chk (bytea, oid);
drop function utf8hex_valid (text);
commit;

col owner for a15 
col TABLESPACE_NAME for a20
col segment_name for a30 
prompt Indexes maiores de 1 GB
select * from 
(select s.owner,s.segment_name,trunc(s.bytes/1024/1024/1024,2) GB,o.last_ddl_time from dba_segments s, dba_objects o
where s.segment_name = o.object_name and s.owner not in ('SYS', 'SYSTEM', 'PERFSTAT') and s.segment_type = 'INDEX'
and o.last_ddl_time < trunc(sysdate - 180) and (s.bytes / 1024 / 1024 / 1024) > 1 order by 3 DESC)
where ROWNUM <= 10;
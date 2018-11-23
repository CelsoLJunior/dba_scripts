col degree for a8
col owner for a25
col TABLESPACE_NAME for a30
select s.owner,
s.segment_name, a.degree,
s.tablespace_name,
s.bytes / 1024 / 1024 "MB",
o.created,
o.last_ddl_time
from dba_segments s, dba_objects o, dba_indexes a
where s.segment_name = o.object_name
and s.segment_name = a.index_name
and s.owner not in ('SYS', 'SYSTEM', 'PERFSTAT')
and s.segment_type = 'INDEX'
and (s.bytes / 1024 / 1024) > 512
and o.last_ddl_time < trunc(sysdate - 90)
order by 5 DESC;
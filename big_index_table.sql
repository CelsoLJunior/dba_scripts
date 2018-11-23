col owner for a15 
col TABLESPACE_NAME for a20
col segment_name for a30 
col object_name for a30 
col table_name for a40 
prompt Indexes maiores por tabela
select i.table_name, s.owner,s.segment_name,trunc(s.bytes/1024/1024/1024,2) GB,o.last_ddl_time from dba_segments s, dba_objects o, dba_indexes i
where s.segment_name = o.object_name and i.INDEX_NAME = s.segment_name and s.owner not in ('SYS', 'SYSTEM', 'PERFSTAT') 
and s.segment_type = 'INDEX'
and i.table_name in (
select segment_name from (
select * from 
(select owner, segment_name, ROUND(sum(bytes)/1024/1024/1024,2) TAM_GB
from dba_segments where SEGMENT_TYPE='TABLE' 
and owner not in ('SYS', 'SYSTEM', 'PERFSTAT')
GROUP BY owner, SEGMENT_NAME having sum(bytes)/1024/1024/1024 > 2 ORDER BY 3 desc)
where ROWNUM <= 10))
and o.last_ddl_time < trunc(sysdate - 180) order by 1,4 DESC;
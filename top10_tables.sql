col owner for a15
col segment_name for a50
select * from 
(select owner, segment_name, ROUND(sum(bytes)/1024/1024/1024,2) TAM_GB
from dba_segments where SEGMENT_TYPE='TABLE' 
and owner not in ('SYS', 'SYSTEM', 'PERFSTAT')
GROUP BY owner, SEGMENT_NAME having sum(bytes)/1024/1024/1024 > 1 ORDER BY 3 desc)
where ROWNUM <= 10;
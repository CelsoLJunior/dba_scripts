col owner for a15
col segment_name for a50
select * from 
(select owner, segment_name, SEGMENT_TYPE, ROUND(sum(bytes)/1024/1024/1024,2) TAM_GB
from dba_segments 
where owner = upper('&OWNER')
GROUP BY owner, SEGMENT_TYPE, SEGMENT_NAME having sum(bytes)/1024/1024/1024 > 1 ORDER BY 3 desc)
where ROWNUM <= 10;
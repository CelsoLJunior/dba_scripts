col segment_name for a30
col owner for a20
select owner, segment_name, ROUND(sum(bytes)/1024/1024,2) TAM_MB from dba_segments where segment_name like upper('%&obj%')
GROUP BY owner,segment_name ORDER BY 1;
col timestamp for a14
col segment_owner for a10
col segment_name for a25
col segment_type for a7
col "Aloc(Mb)" for 999999.99
col "Usado(Mb)" for 999999.99
col "Cresc(Mb)" for 999999.99
select s1.timestamp,s1.segment_owner,s1.segment_name,s1.segment_type,
       round(s1.total_bytes/1024/1024,2) "Aloc(Mb)",
       round((s1.total_bytes - s1.unused_bytes)/1024/1024,2) "Usado(Mb)",
       round(((s1.total_bytes - s1.unused_bytes) - 
              (s2.total_bytes - s2.unused_bytes))/1024/1024,2) "Cresc(Mb)"
from storage s1, storage s2, dba_segments seg
where s1.run_id = s2.run_id + 1 and
      s1.segment_owner = s2.segment_owner and
      s1.segment_name = s2.segment_name and 
      s1.segment_type = s2.segment_type and
--    s1.segment_name like upper('Segmentname') and
      s1.segment_name = seg.segment_name and
      s1.segment_type = seg.segment_type and
      s1.segment_owner= seg.owner and
      seg.tablespace_name = upper('&tablespace')
/

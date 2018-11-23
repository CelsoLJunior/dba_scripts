break on report skip 1
compute avg of "Aloc(Mb)" on report
compute avg of "Usado(Mb)" on report
compute avg of "Cresc(Mb)" on report
col timestamp for a10
col segment_owner for a10
col segment_name for a25
col "Aloc(Mb)" for 99999999999
col "Usado(Mb)" for 99999999999
col "Cresc(Mb)" for 99999999999

select /*+ use_hash(s1,s2) */
       to_char(max(s1.timestamp),'dd/mm/yyyy') timestamp,
       round(sum(s1.total_bytes)/1024/1024) "Aloc(Mb)",
       round((sum(s1.total_bytes) - sum(s1.unused_bytes))/1024/1024) "Usado(Mb)",
       round(((sum(s1.total_bytes) - sum(s1.unused_bytes)) -
	          (sum(s2.total_bytes) - sum(s2.unused_bytes)))/1024/1024) "Cresc(Mb)"
from  system.imm_storage s1, system.imm_storage s2
where s1.run_id = s2.run_id + 1 and
      s1.segment_owner = s2.segment_owner and
      s1.segment_name = s2.segment_name and
      s1.segment_type = s2.segment_type and
      nvl(s1.partition_name,'xxx') = nvl(s2.partition_name,'xxx')
      and s1.timestamp >= trunc (sysdate - &1)
group by s1.run_id
Order by to_date(timestamp,'dd/mm/yyyy')
/
clear computes
clear breaks

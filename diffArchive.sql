set lines 200
col name format a40
col value format a20
select * from v$dataguard_stats;

select (b.last_seq - a.applied_seq) ||'|'||'rac'||a.thread# LAG
from (SELECT thread#
max(SEQUENCE#) applied_seq,
max(next_time) last_app_timestamp,
FROM gv$ARCHIVED_LOG
WHERE APPLIED = 'YES'
GROUP BY THREAD#) a,
(SELECT thread#
max(SEQUENCE#) last_seq,
FROM gv$ARCHIVED_LOG
GROUP BY THREAD#) b
where a.thread# = b.thread# 12;
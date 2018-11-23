set verify off

col WHAT for a100
col INTERVAL for a25
col LAST_DATE for a20
col NEXT_DATE for a20
col LOG_USER for a10
undef job
select instance,log_user, job, interval, last_date, next_date, failures, broken, what
from dba_jobs
where job=&job;
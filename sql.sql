undef hash_value
set verify off;
select --sql_id,
executions,
buffer_gets,
disk_reads,
round(buffer_gets/decode(executions,0,1,executions),2) Buff_p_exec,
round(rows_processed/decode(executions,0,1,executions),2) Rows_per_exec,
rows_processed,
first_load_time,
parsing_user_id
from v$sqlarea a
where a.hash_value = &&hash_value
/
select sql_text from v$sqltext
where hash_value = &&hash_value
order by piece
/
undef hash_value
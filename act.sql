col username for a20
col machine for a30
col osuser for a30
col spid for a10
select a.sid,a.serial#,b.spid,a.username, last_call_et/60 "Idle - min",a.sql_hash_value,
 osuser,a.machine,a.program,a.status,logon_time,server
 from v$session a, v$process b
 where a.username is not null
 and a.paddr = b.addr
 and status = 'ACTIVE'
 order by 5
/
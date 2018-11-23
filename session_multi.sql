col spid for a10
col username for a20
col osuser for a25
col machine for a30
col program for a25
SELECT 
	a.sid,
	a.serial#,
	b.spid,
	a.username,
	a.status,
	a.saddr,
	a.sql_hash_value, -- hash da sessão atual
	a.prev_hash_value, -- hash da sessão anterior
	osuser,
	a.machine,
	a.program,
	last_call_et / 60 "Idle(min)",
	logon_time,server
FROM gv$session a, v$process b
WHERE 
	a.sid in (3255,2952) AND
	a.paddr = b.addr
ORDER BY 4
/
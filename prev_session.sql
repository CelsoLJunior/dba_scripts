SELECT 
	a.sid,
	a.serial#,
	b.spid,
	a.username,
	a.status,
	a.saddr,
	a.prev_hash_value,
	osuser,
	a.machine,
	a.program,
	a.status,
	last_call_et / 60 "Idle(min)",
	logon_time,server
FROM v$session a, v$process b
WHERE 
	a.sid=&sid AND
	a.paddr = b.addr
ORDER BY 4
/
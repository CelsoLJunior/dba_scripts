set line 1000
col sid for 9999
col username for a14
col event for a27
col p1text for a9
col p2text for a9
col p3text for a9
col p1 for 9999999999999999
col p2 for 999999
col p3 for 999999
col seconds_in_wait for 99999999 heading (s)
col machine for a30
col program for a50
col osuser for a16
SELECT	/*+ rule */
		s.sid, p.spid, s.username, w.seconds_in_wait, w.event,
		--substr(w.p1text,1,9),
		w.p1text, w.p1, w.p2text, w.p2, w.p3text, w.p3,	s.sql_hash_value,
		s.machine, s.osuser, s.program, s.logon_time, s.server
FROM	v$session s, v$session_wait w, v$process p
WHERE	s.sid = w.sid AND
		s.paddr = p.addr(+) AND
		w.event <> 'SQL*Net message from client' AND
		w.event <> 'Null event' AND
		w.event <> 'null event' AND
		w.event <> 'rdbms ipc message' AND
		w.event <> 'pmon timer' AND
		w.event <> 'smon timer' AND
		--w.event <> 'SQL*Net message to client' AND
		w.event <> 'pipe get' AND
		w.event <> 'jobq slave wait' AND
		w.event not like 'Streams AQ%' AND
		1=1
ORDER BY	s.username,	s.sql_hash_value, s.sid;

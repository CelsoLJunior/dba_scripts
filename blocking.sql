col BLOCKER for a10
col WAITER for a10
select /*+ rule ordered */ DECODE( block, 0, '       ','YES    ') BLOCKER,
       DECODE( block, 0, 'YES    ','       ') WAITER,
       SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK
from gv$lock where (ID1,ID2,TYPE) in
(select ID1,ID2,TYPE from gv$lock where request>0)
order by id1,id2,waiter;


--select SID from
col spid for a7
col username for a20
col osuser for a25
col machine for a31
col program for a20
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
	a.sid in (select SID from gv$lock where (ID1,ID2,TYPE) in (select ID1,ID2,TYPE from gv$lock where request>0) and block > 0 ) AND
	a.paddr = b.addr
ORDER BY 4;
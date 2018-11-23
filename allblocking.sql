Prompt Blocking:
col username for a15
col blocker for a8
col sid for 99999
col waiter for a8
col osuser for a16
col machine for a25
col program for a31
col status for a10
col sql_hash_value for 99999999999
col prev_hash_value for 99999999999
SELECT /*+ rule ordered */
DECODE( l.block, 0, '  ', 'YES' ) BLOCKER,
DECODE( l.request, 0, '  ', 'YES' ) WAITER,
s.sid, s.username, s.osuser, s.machine, s.program, s.status, s.SQL_HASH_VALUE, s.PREV_HASH_VALUE, l.ctime
FROM v$lock l, v$session s
WHERE (l.request > 0 OR l.block > 0)
and l.sid = s.sid
ORDER BY l.id2, block DESC
/


Prompt SQLs das sessões blockers:

col sql_text for a90
col user_name for a18
col hash_value for 9999999999999
col I for 9
set lines 500

with sess as
(
select /*+ materialize */ sid, inst_id, s.blocking_session, s.blocking_instance, s.SADDR
from gv$session s
)
,blockers as
(
select /*+ leading(tbl) */ sess.sid, sess.inst_id, sess.SAddr, sess.blocking_session,
sess.blocking_instance
from sess,
(select distinct blocking_session, blocking_instance
from sess
where blocking_session is not null) tbl
where sess.sid = tbl.blocking_session
and sess.inst_id = tbl.blocking_instance
and sess.blocking_session is null
)
select /*+ leading(b) */ b.sid, b.inst_id, oc.HASH_VALUE, oc.SQL_ID, oc.sql_text
from blockers b
inner join gv$open_cursor oc
on b.inst_id = oc.inst_id
and b.sid = oc.sid
and b.SAddr = oc.SAddr;
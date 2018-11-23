undef sid
undef level
select 'exec sys.dbms_system.set_ev('||sid||','||serial#||', 10046,12,'''')'
from v$session
where sid = &&sid
/
undef sid
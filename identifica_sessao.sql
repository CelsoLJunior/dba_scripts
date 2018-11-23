col owner for a15
col object for a30
accept OBJ prompt 'Nome do Objeto'
select distinct a.sid,b.serial#, b.username, a.object, a.type, b.osuser, b.status, b.machine,  b.client_info--,a.inst_id
from v$access a, v$session b
where a.sid = b.sid
and a.object like upper('%&OBJ%')
order by 5,3,1,2,4,6
/
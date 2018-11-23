undef owner
select owner,object_type,count(*)
from dba_objects
where owner like upper('&Owner')
and object_name not like 'BIN$%'
group by owner,object_type
order by owner,object_type
/

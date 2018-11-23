Undef obj;
Undef Own;
col object_name for a30
col owner for a20
select owner,OBJECT_NAME, OBJECT_TYPE, CREATED, LAST_DDL_TIME, status
  from dba_objects 
 where object_name like upper('%&obj%')
   and owner like '%' || upper('&own') || '%'
order by 1,3,2
/
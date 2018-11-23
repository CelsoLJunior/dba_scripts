undef owner
undef object_name
undef object_type
set long 2000000
col ddl for a250
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);
select dbms_metadata.get_ddl (decode(object_type,
                                          'TABLE PARTITION','TABLE',
                                          'INDEX PARTITION','INDEX',
                                          'MATERIALIZED VIEW','MATERIALIZED_VIEW',
                                          'MATERIALIZED VIEW LOG','MATERIALIZED_VIEW_LOG', --documentational only
                                          'PACKAGE BODY','PACKAGE_BODY',
                                          object_type)   ,
                              object_name,
                              owner) DDL
from dba_objects
where
      object_name like upper('%&Object_name%') and
      owner like upper('&Owner') and
      object_type like upper('&Object_type') --and
--      object_type not in ('TABLE PARTITION','INDEX PARTITION');
-- EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);
-- SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT','SCOTT') FROM DUAL;

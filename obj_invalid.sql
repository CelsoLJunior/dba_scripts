col object_name for a40
col owner for a25
col object_type for a15


set lines 1001 pages 1001
select OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS from dba_objects where owner='&NOME_OWNER' and status='INVALID';

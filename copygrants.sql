undef copyuser
undef newuser
SET VERIFY OFF
prompt CREATE_USER
prompt ===========
-- SE SENHA TIVER CARACTERES ESPECIAIS, USAR:
-- SET DEFINE OFF
-- E ASPAS DUPLAS EM TORNO DA SENHA
select 'create user &&newuser identified by <SENHA> default tablespace '||default_tablespace||' temporary tablespace '||temporary_tablespace||';'
from dba_users
where username = upper('&&copyuser');
select 'grant unlimited tablespace to '||upper('&&newuser')||';' from dual;
prompt
prompt DBA_SYS_PRIVS
prompt =============
select 'grant '||privilege||' to '||upper('&&newuser')||';' from dba_sys_privs where grantee = upper('&&copyuser');
prompt
prompt DBA_ROLE_PRIVS
prompt ==============
select 'grant '||granted_role||' to '||upper('&&newuser')||';' from dba_role_privs where grantee = upper('&&copyuser');
prompt
prompt DBA_TAB_PRIVS
prompt =============
select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||upper('&&newuser')||';' from dba_tab_privs where grantee = upper('&&copyuser');
prompt
prompt ALL_TABLES
prompt ==========
select 'grant SELECT, UPDATE, INSERT, DELETE on '||owner||'.'||table_name||' to '||upper('&&newuser')||';' from dba_tables where owner = upper('&&copyuser');
prompt
prompt CHECK_FINAL
prompt ===========
col OBJECT_NAME for a50
Undef obj;
Undef Own;
col object_name for a30
col owner for a20
select owner,OBJECT_NAME, OBJECT_TYPE, CREATED, LAST_DDL_TIME, status from dba_objects where owner like '%' || upper('&&copyuser') || '%' order by 1,3,2;
SET VERIFY ON
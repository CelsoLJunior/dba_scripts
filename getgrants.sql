undef grantee
prompt
prompt DBA_SYS_PRIVS
prompt =============
select 'grant '||privilege||' to '||upper('&&grantee')||';' from dba_sys_privs where grantee = upper('&&grantee');
prompt
prompt DBA_ROLE_PRIVS
prompt ==============
select 'grant '||granted_role||' to '||upper('&&grantee')||';' from dba_role_privs where grantee = upper('&&grantee');
prompt
prompt DBA_TAB_PRIVS
prompt =============
select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||upper('&&grantee')||';' from dba_tab_privs where grantee = upper('&&grantee');
prompt
prompt ALL_TABLES
prompt ==========
select 'grant SELECT, UPDATE, INSERT, DELETE on '||owner||'.'||table_name||' to '||upper('&&grantee')||';' from dba_tables where owner = upper('&&grantee');
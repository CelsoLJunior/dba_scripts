select 'grant '||granted_role|| ' to &&UsuarioCriado'|| ';'
from dba_role_privs where grantee = upper('&&UsuarioExistente')
union
select 'grant '||PRIVILEGE|| ' to &UsuarioCriado'|| ';'
from dba_sys_privs where grantee = upper('&UsuarioExistente')
union
select 'grant '||privilege|| ' on '||owner||'.'||table_name|| ' to &UsuarioCriado'|| ';'
from dba_tab_privs where grantee = upper('&UsuarioExistente')
/
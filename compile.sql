﻿prompt > OBJETOS INVALIDOS BANCO
select 'alter '||decode(object_type,'PACKAGE BODY','PACKAGE',object_type) ||' '||owner||'."'||object_name||'" compile '|| decode(object_type,'PACKAGE BODY','BODY;',';') from dba_objects where status = 'INVALID' order by object_type desc;
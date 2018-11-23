undef owner
set lines 5000
set pages 5000
select 'alter table '||owner||'.'||table_name||' drop constraint '||constraint_name||';'
from dba_constraints
where owner like upper('&&Owner') and
      r_owner like upper('&&Owner') and
      constraint_type = 'R' and
      owner not in ('SYS','SYSTEM','OUTLN','DBSNMP','PUBLIC')
union all
select 'drop '||object_type||' '||owner||'.'||object_name||';'
from dba_objects
where object_type in ('PACKAGE','SEQUENCE','SYNONYM','VIEW',
                      'PROCEDURE','FUNCTION') and
      owner like upper('&&Owner') and
      owner not in ('SYS','SYSTEM','OUTLN','DBSNMP','PUBLIC')
union all
select 'drop     table '||owner||'.'||table_name||';'
from dba_tables
where owner like upper('&&Owner') and
      owner not in ('SYS','SYSTEM','OUTLN','DBSNMP','PUBLIC')
union all
select 'drop synonym '||owner||'.'||synonym_name||';'
from dba_synonyms
where owner like upper('&&Owner') and
      table_owner not in ('SYS','SYSTEM','OUTLN','DBSNMP','PUBLIC')
union all
select 'drop TYPE '||TYPE_name||';'
from dba_types
where owner like upper('&&Owner') and
      owner not in ('SYS','SYSTEM','OUTLN','DBSNMP','PUBLIC')
/
undef owner
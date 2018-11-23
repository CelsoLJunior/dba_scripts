col text for a250
select line,text
from dba_source
where name like upper('&Proc_Name') and
      owner like upper('&Owner%') and
      line >= &linha_inicial and
      line <= &linha_final 
order by type,name,line
/

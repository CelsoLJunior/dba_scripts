select DATA, DATABASENAME, TABLENAME, DATA_SIZE, RESERVED, INDEX_SIZE, UNUSED
from DBA_INFO_TABLE
where TABLENAME in (
  select top 10 TABLENAME
  from DBA_INFO_TABLE
  where DATA = CONVERT (date, GETDATE())
  order by DATA_SIZE desc
 )
and DATA = CONVERT (date, GETDATE())
order by DATA desc, DATA_SIZE desc;
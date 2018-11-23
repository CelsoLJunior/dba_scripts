col OWNER for a10
col INDEX_NAME for a20
col INDEX_TYPE for a10
col TABLE_OWNER for a10
col TABLE_NAME for a15
col column_name for a15
col column_position for 9
select di.OWNER, di.INDEX_NAME, di.INDEX_TYPE, di.TABLE_OWNER, di.TABLE_NAME, di.DISTINCT_KEYS, di.UNIQUENESS, dic.column_position, dic.column_name 
from dba_indexes di 
inner join Dba_ind_columns  dic
on di.INDEX_NAME = dic.INDEX_NAME
where di.STATUS = 'UNUSABLE'
order by di.INDEX_NAME,dic.COLUMN_POSITION;
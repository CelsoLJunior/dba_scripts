col TABLESPACE for a35
SELECT
a.tablespace Tablespace,
trunc(a.total,2) "Total (MB)",
trunc(a.utilizado,2) "Utilizado (MB)",
trunc(a.total-a.utilizado,2) "Livre (MB)",
trunc((a.total-a.utilizado)*100/a.total,2) "% Livre"
from (
select
d.TABLESPACE_NAME tablespace,
sum(d.bytes)/1024/1024 Total,
(sum(d.bytes)-  (select
SUM(bytes)
from
dba_free_space
where
tablespace_name=d.TABLESPACE_NAME)) /1024/1024 Utilizado
from
dba_data_files d
group by
d.TABLESPACE_NAME
) a order by 2 DESC
/

select * from system.imm$sgt_tbs_config_folga;
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
) a order by 4 DESC;

select * from system.imm$sgt_tbs_config_folga;

prompt Status Tablespaces:
prompt

set serveroutput on
declare
   a number;
   b number;
begin
 system.imm$sgt_pkg.PRC_TESTA_FOLGA_TABLESPACES (a,b,FALSE);
 dbms_output.put_line('TBS em advertencia: '||a);
 dbms_output.put_line('TBS criticas: '||b);
end;
/

-- NEW FEATURE

prompt DEFAULT

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
) a
where a.tablespace not in (select TABLESPACE_NAME from system.imm$sgt_tbs_config_folga where TABLESPACE_NAME <> '<DEFAULT>')
and trunc((a.total-a.utilizado)*100/a.total,2) < (select PERCENTUAL_FOLGA_ADVERTENCIA from system.imm$sgt_tbs_config_folga where TABLESPACE_NAME = '<DEFAULT>')
order by 4 DESC;


prompt OTHERS

SELECT
a.tablespace Tablespace,
trunc(a.utilizado,2) "Utilizado (MB)",
trunc(a.total-a.utilizado,2) "Livre (MB)",
trunc((a.total-a.utilizado)*100/a.total,2) "% Livre",
NVL(a.ADVERTENCIA, 10) ADVERTENCIA, NVL(a.CRITICO, 5) CRITICO
from (
	select
	d.TABLESPACE_NAME tablespace,
	tables.PERCENTUAL_FOLGA_CRITICO CRITICO,
	tables.PERCENTUAL_FOLGA_ADVERTENCIA ADVERTENCIA,
	sum(d.bytes)/1024/1024 Total,
	(sum(d.bytes)-  
		(
		select
		SUM(bytes)
		from
		dba_free_space
		where
		tablespace_name=d.TABLESPACE_NAME
		)
	) /1024/1024 Utilizado
	from
	dba_data_files d
	left join system.imm$sgt_tbs_config_folga tables on tables.TABLESPACE_NAME = d.TABLESPACE_NAME
	group by d.TABLESPACE_NAME, tables.PERCENTUAL_FOLGA_CRITICO, tables.PERCENTUAL_FOLGA_ADVERTENCIA
) a 
where trunc((a.total-a.utilizado)*100/a.total,2) < a.ADVERTENCIA
order by trunc((a.total-a.utilizado)*100/a.total,2);
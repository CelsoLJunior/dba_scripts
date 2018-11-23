set serveroutput on
set feedback off
declare
a number;
b number;
begin
 system.imm$sgt_pkg.PRC_TESTA_FOLGA_TABLESPACES (a,b,FALSE);
 dbms_output.put_line('Warning: ' || a);
 dbms_output.put_line('High: ' || b);
end;
/


-- NEW FEATURE

SELECT
a.tablespace Tablespace,
trunc((a.total-a.utilizado)*100/a.total,2) Livre,
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
	group by
	d.TABLESPACE_NAME, tables.PERCENTUAL_FOLGA_CRITICO, tables.PERCENTUAL_FOLGA_ADVERTENCIA
) a 
where trunc((a.total-a.utilizado)*100/a.total,2) < a.ADVERTENCIA
order by trunc((a.total-a.utilizado)*100/a.total,2);
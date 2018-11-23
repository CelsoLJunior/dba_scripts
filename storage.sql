alter session set nls_Date_format = 'dd/mm/rrrr';
alter session set NLS_Numeric_Characters = ',.';
set lines 1000;
set pages 1000;
 select k1.*,k1.usado-k2.usado Crescimento from
 (select rownum linha,t.* from (
 select
    trunc(TIMESTAMP),
    (sum(total_bytes)/1024/1024)+(sum(UNUSED_BYTES)/1024/1024) Alocado,
    sum(total_bytes)/1024/1024 Usado
 from
    system.imm_storage
 group by
    run_id,trunc(TIMESTAMP)
 order by 1
 ) t
 ) k1,
 (select rownum+1 linha, t.* from (
 select
    trunc(TIMESTAMP),
    (sum(total_bytes)/1024/1024)+(sum(UNUSED_BYTES)/1024/1024) Alocado,
    sum(total_bytes)/1024/1024 Usado
 from
    system.imm_storage
 group by
    run_id,
    trunc(TIMESTAMP)
 order by 1
 ) t
 ) k2
 where k1.linha = k2.linha (+)
 order by k1.linha
/
col "Tamanho do Banco" format a15
col "Espaco Livre" format a15
col "Espaco Utilizado" format a15
select  round(sum(used.bytes) / 1024 / 1024 ) || ' MB' "Tamanho do Banco"
,       round(sum(used.bytes) / 1024 / 1024 ) - round(free.p / 1024 / 1024) || ' MB' "Espaco Utilizado"
,       round(free.p / 1024 / 1024) || ' MB' "Espaco Livre"
,       round(sum(used.bytes) / 1024 / 1024 / 1024 ) || ' GB' "Tamanho do Banco"
,       round(sum(used.bytes) / 1024 / 1024 / 1024 ) - round(free.p / 1024 / 1024 / 1024) || ' GB' "Espaco Utilizado"
,       round(free.p / 1024 / 1024 / 1024) || ' GB' "Espaco Livre"
from    (select bytes
        from    v$datafile
        union   all
        select  bytes
        from    v$tempfile
        union   all
        select  bytes
        from    v$log) used
,       (select sum(bytes) as p
        from dba_free_space) free
group by free.p;
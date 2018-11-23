set lines 1001 pages 1001
col host_name for a20
alter session set nls_date_format='hh24:mi:ss dd/mm/yyyy';
alter session set nls_language='AMERICAN';
select instance_name, host_name, status, startup_time from v$instance;
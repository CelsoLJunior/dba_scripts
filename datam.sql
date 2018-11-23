set verify off
col tablespace for a20
col datafile for a60
col file_id for 9999
col tamanho_em_MB for 999999
col Max_MB for a10
col Free for a10
col autoextensible for a3

undef tablespace


SELECT
 tablespace_name AS tablespace, file_name AS datafile,file_id, bytes/1024/1024 AS tamanho_em_MB, 
trunc(maxbytes/1024/1024)||'Mb' AS Max_MB,
		trunc(((maxbytes/1024/1024) - (bytes/1024/1024)))||'Mb' AS Free,autoextensible
 FROM dba_data_files
 WHERE tablespace_name=upper('&Tablespace')
ORDER BY 4 DESC,5,2 DESC;
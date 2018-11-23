SELECT  rq.session_id,         
		SS.host_name, 
		SS.program_name, 
		SS.cpu_time, 
		[database] = DB_NAME(rq.database_id),
		rq.start_time,
		DATEDIFF(S, rq.start_time, GETDATE()) [seconds],
		rq.row_count, 
		rq.status, 
		rq.blocking_session_id, 
		rq.percent_complete,
		rq.wait_type,
		rq.last_wait_type,
        SUBSTRING(st.text, (rq.statement_start_offset/2) + 1,

         ((CASE statement_end_offset 

          WHEN -1 THEN DATALENGTH(st.text)

          ELSE rq.statement_end_offset END 

            - rq.statement_start_offset)/2) + 1) AS statement_text, 
		st.text as full_statement

FROM sys.dm_exec_requests AS rq
	CROSS APPLY sys.dm_exec_sql_text(rq.sql_handle) st
	LEFT JOIN sys.dm_exec_sessions SS
		ON SS.session_id =rq.session_id
WHERE   rq.session_id <> @@SPID
    AND rq.session_id > 50
	AND rq.wait_type <> 'OLEDB'
order by SS.cpu_time desc
-- OTHER INFO
-- Desconsiderar a sexta linha, adicionada apenas para tirar a marca azul da célula
Use Master
Go

DECLARE @Criteria INT 
set @Criteria= 4

DECLARE @Select_Criteria NVARCHAR(MAX)

DECLARE @OrderBy_Criteria NVARCHAR(MAX)
SET @OrderBy_Criteria = N''--AVG_

DECLARE @Top INT 
SET @Top = 6

SELECT @Select_Criteria = CASE @Criteria
	WHEN 4 THEN 'CPU'
END

SELECT 
	query_rank,
	convert (varchar, creation_time, 103) + ' ' + convert (varchar, creation_time, 108) creation_time,
	execution_count,
CASE @Select_Criteria
	WHEN 'Logical Reads' then total_logical_reads
	WHEN 'Physical Reads' then total_physical_reads
	WHEN 'Logical Writes' then total_logical_writes
	WHEN 'CPU' then total_worker_time
	WHEN 'Duration' then total_elapsed_time / 1000
	WHEN 'CLR Time' then total_clr_time
END TOTAL
from (select s.*, row_number() over(order by charted_value desc, last_execution_time desc) as query_rank from
		 (select *, 
				CASE @OrderBy_Criteria + @Select_Criteria
					WHEN 'Logical Reads' then total_logical_reads
					WHEN 'AVG_Logical Reads' then total_logical_reads / execution_count
					WHEN 'Physical Reads' then total_physical_reads
					WHEN 'AVG_Physical Reads' then total_physical_reads / execution_count
					WHEN 'Logical Writes' then total_logical_writes
					WHEN 'AVG_Logical Writes' then total_logical_writes / execution_count
					WHEN 'CPU' then total_worker_time
					WHEN 'AVG_CPU' then total_worker_time / execution_count
					WHEN 'Count' then execution_count
					WHEN 'Duration' then total_elapsed_time
					WHEN 'AVG_Duration' then total_elapsed_time / execution_count
					WHEN 'CLR Time' then total_clr_time
					WHEN 'AVG_CLR Time' then total_clr_time / execution_count
				END as charted_value 
			from sys.dm_exec_query_stats) as s where s.charted_value > 0 and execution_count > CASE WHEN @OrderBy_Criteria LIKE 'AVG%' THEN 1000 ELSE 0 END) as qs
	cross apply msdb.MS_PerfDashboard.fn_QueryTextFromHandle(sql_handle, statement_start_offset, statement_end_offset) as qt
where qs.query_rank <= @Top;

-- QUERY_TEXT
Use Master
Go

DECLARE @Criteria INT 
set @Criteria= 4

DECLARE @Select_Criteria NVARCHAR(MAX)

DECLARE @OrderBy_Criteria NVARCHAR(MAX)
SET @OrderBy_Criteria = N''--AVG_

DECLARE @Top INT 
SET @Top = 5

SELECT @Select_Criteria = CASE @Criteria
	WHEN 4 THEN 'CPU'
END

SELECT 
	--query_rank,
	REPLACE(qt.query_text, CHAR(13) + CHAR(10), ' ') as query_text
	--convert (varchar, creation_time, 103) + ' ' + convert (varchar, creation_time, 108) creation_time,
	--execution_count,
-- worker time
from (select s.*, row_number() over(order by charted_value desc, last_execution_time desc) as query_rank from
		 (select *, 
				CASE @OrderBy_Criteria + @Select_Criteria
					WHEN 'CPU' then total_worker_time
				END as charted_value 
			from sys.dm_exec_query_stats) as s where s.charted_value > 0 and execution_count > CASE WHEN @OrderBy_Criteria LIKE 'AVG%' THEN 1000 ELSE 0 END) as qs
	cross apply msdb.MS_PerfDashboard.fn_QueryTextFromHandle(sql_handle, statement_start_offset, statement_end_offset) as qt
where qs.query_rank <= @Top;
CREATE TABLE #TMP_Log (LogDate smalldatetime, ProcessInfo varchar(300), Texto [varchar](8000))


CREATE TABLE #TMP_SHELL (ARQUIVO [varchar](8000))

DECLARE 
	@vCMD			[varchar](8000), 
	@vQTDE_ARQUIVO	[int], 
	@vI				[int], 
	@vDIR_FILES		[varchar](8000),
	@vFILE			[varchar](8000),
	@vSQL			[varchar](8000),
	@vDB_NAME		[varchar](200)

/* Descobrir o PATH dos arquivos de LOG do SQL Server e informar no parâmetro abaixo */
SET @vDIR_FILES = '"C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\LOG\'

/* Filtra pelo nome do arquivo */
SET @vCMD = 'ERRORLOG.*"'

SET @vCMD = 'DIR ' + @vDIR_FILES + @vCMD+' /s /b /o:n'

--DELETE #TMP_SHELL

INSERT #TMP_SHELL
EXEC Master.dbo.xp_cmdshell @vCMD

declare @id int
declare @max int
declare @valor varchar

set @max = (select count(*) from #TMP_SHELL where Arquivo is not null)

set @id = 0

While @id < @max
Begin
    
	/* Analisar principalmente os erros com severidade maior que 16 */
	insert into #TMP_Log
	exec sp_readerrorlog @id ,1,'Error'

	Set @id = @id + 1
	
End

----Drop table #TMP_SHELL


--Select substring(texto, charindex('Severity:',texto)+9, 3), * From #TMP_Log
--Where texto like 'Error:%'
--	and convert(int, substring(texto, charindex('Severity:',texto)+9, 3)) >= 17
--order by substring(texto, charindex('Severity:',texto)+9, 3)


----delete #TMP_Log
----where texto  = 'Error: 18456, Severity: 14, State: 16.'

--select * from #TMP_Log
--where Logdate >= '2017-05-01 15:30:00' and Logdate <= '2017-07-05 12:00:00'
--order by logdate
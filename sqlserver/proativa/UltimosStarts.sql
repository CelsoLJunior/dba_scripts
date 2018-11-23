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
SET @vDIR_FILES = '"H:\Microsoft SQL Server\MSSQL.1\MSSQL\LOG\'

/* Filtra pelo nome do arquivo */
SET @vCMD = 'ERRORLOG.*"'

SET @vCMD = 'DIR ' + @vDIR_FILES + @vCMD+' /s /b /o:n'

DELETE #TMP_SHELL

INSERT #TMP_SHELL
EXEC Master.dbo.xp_cmdshell @vCMD

declare @id int
declare @max int
declare @valor varchar

set @max = (select count(*) from #TMP_SHELL where Arquivo is not null)

set @id = 0

While @id < @max
Begin
    
	/* Filtrar pelo LOG de quando o SQL Server é iniciado */
	exec sp_readerrorlog @id ,1,'SQL Server is starting'

	Set @id = @id + 1
	
End

Drop table #TMP_SHELL

--- Verifica os GAPS dos backups LOG - 20 em 20 minutos
declare 
	@Database varchar(300),
	@Type char(1),
	@backupDate smalldatetime,
	@backupDatePrevious smalldatetime,
	@Gap smalldatetime

declare CrBackups Cursor For

	--Listar os últimos backups realizados com SUCESSO
	SELECT  sd.name as Banco,
			CASE bs.TYPE
			WHEN 'D' THEN 'DADOS'
			WHEN 'L' THEN 'LOG'
			END AS Type,
			bs.backup_start_date as backupDate
	FROM    master..sysdatabases sd
			Left outer join msdb..backupset bs on rtrim(bs.database_name) = rtrim(sd.name)
			left outer JOIN msdb..backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
	WHERE sd.name = 'Dativa' 
		and bs.TYPE = 'L'
		and bs.backup_start_date > getdate()- 3
	Order by sd.name,backupDate desc

Open CrBackups
Fetch Next From CrBackups
Into @Database, @Type, @backupDate

While @@Fetch_status = 0
Begin
	Set @backupDatePrevious = @backupDate
	
	Fetch Next From CrBackups
	Into @Database, @Type, @backupDate

	
	If (Datediff (minute, @backupDate, @backupDatePrevious ) > 120)
		and ( convert(varchar(10), @backupDatePrevious , 108) > '03:00' )
	begin
		Select 'Gap: ' + Convert(varchar(16), Dateadd(day, -1, @backupDatePrevious), 120)
		Set @Gap = Convert(varchar(16), Dateadd(day, -1, @backupDatePrevious), 120)
	end
	
End

Close CrBackups
Deallocate CrBackups
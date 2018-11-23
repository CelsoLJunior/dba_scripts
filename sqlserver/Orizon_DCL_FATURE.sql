use msdb
Go
Select @@ServerName, Getdate()
go
sp_msforeachdb
'
select
''?'' as DBName,
rp.name as database_role, mp.name as database_user
from [?].sys.database_role_members drm
join [?].sys.database_principals rp on (drm.role_principal_id = rp.principal_id)
join [?].sys.database_principals mp on (drm.member_principal_id = mp.principal_id)
WHERE ''?'' not in (''master'', ''msdb'', ''model'', ''tempdb'', ''EXPURGO'')
AND mp.name <> ''dbo''
AND mp.name like ''%renata.alves%'' -- Alterar nome do usuário
order by mp.name'


-- Usuário não tem acesso ao banco de dados do Fature.
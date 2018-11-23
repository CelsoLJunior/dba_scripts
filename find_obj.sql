col owner for a30
col object_name for a50
col object_type for a30
undef obj_name
conn guilhermew/dimed2016@CARTAO
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
conn guilhermew/dimed2016@CEDE
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
conn guilhermew/dimed2016@COMR
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
conn guilhermew/dimed2016@SCA
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
conn guilhermew/dimed2016@PFO
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
conn guilhermew/dimed2016@CORP
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
conn bniffa/d1m3d1l3gr4@msaf
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
conn guilhermew/dimed2016@bidb
select NAME from v$database;
select owner,object_name,object_type,status from dba_objects where object_name like upper('%&&obj_name%');
undef obj_name
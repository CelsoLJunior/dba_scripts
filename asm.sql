COL "% FREE" FOR A6
COL NAME FOR A15
select group_number, name, state,trunc(total_mb/1024,2) total_Gb,trunc(free_mb/1024,2) free_Gb,trunc(100*free_mb/total_mb,1) ||'%' AS "% FREE" from V$ASM_DISKGROUP_STAT;
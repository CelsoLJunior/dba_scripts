col maquina for a12
col userbanco for a8
col "%DONE" for a10
col EXECUCAO for a12
col MENSAGEM for a80
col RESTANTE for a20
col osuser for a12
 select  s.sid                                                                   SId,
         s.username                                                              USERBANCO,
         s.osuser                                                           ,
         s.machine                                                               MAQUINA,
         s.SQL_HASH_VALUE,
    TRUNC((sofar/totalwork)*100,2) || '%'                                   "%DONE",
         to_char(l.start_time,'DD/MM/YYYY hh24:mi:ss')                           INICIO,
         l.elapsed_seconds || ' segundos'                                        EXECUCAO,
         to_char(sysdate + (l.TIME_REMAINING/(24*3600)),'DD/MM/YYYY hh24:mi:ss') FINAL,
         'faltam '||l.TIME_REMAINING || ' segundos'                              RESTANTE,
         l.message                                                               MENSAGEM
 from v$session s, v$session_longops l
 where s.sid = l.sid
  --       and s.status = 'ACTIVE'
         and (sofar/totalwork) < 1
 --        and s.osuser = 'www'
         and totalwork > 0
 order by s.machine
/

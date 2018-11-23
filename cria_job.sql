select to_char(sysdate,'dd/mm/yyyy hh24:mi:ss') Data_atual from dual;
accept n_dt        prompt 'Proxima execucao (dd/mm/yyyy hh24:mi:ss):'
accept inte        prompt 'String do intervalo.....................:'
accept p_what      prompt 'What....................................:'
Accept p_inst      prompt 'Instance................................:'
set serveroutput on;
declare
  jobno number;
begin
 DBMS_JOB.SUBMIT ( Job             => JOBNO,
                   what            => '&p_what',
                   next_date       => to_date('&n_dt','dd/mm/yyyy hh24:mi:ss'),
                   interval        => '&inte',
                   NO_PARSE        => Null,
                   Instance        => &p_inst
             );
 COMMIT;
 DBMS_OUTPUT.PUT_LINE ('JOB:'||JOBNO||' CRIADO.');
end;

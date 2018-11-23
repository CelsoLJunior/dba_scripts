prompt TESTA FOLGA
set serveroutput on
declare
   a number;
   b number;
begin
 system.imm$sgt_pkg.PRC_TESTA_FOLGA_TABLESPACES (a,b,FALSE);
 dbms_output.put_line('TBS em advertencia: '||a);
 dbms_output.put_line('TBS criticas: '||b);
end;
/
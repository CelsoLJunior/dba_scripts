prompt <table border="1" align='center' summary="Script output">
set verify off
set serveroutput on
set heading off
var cres_diario_mb number;
var disp_mb number;
var used_mb number;
var free number;
var dias number;
begin
   system.imm$sgt_pkg.PRC_ESTIMATIVA_CRESCIMENTO (30,:cres_diario_mb,:disp_mb,:used_mb,:dias);
   DBMS_OUTPUT.PUT_LINE('<tr><th>Crescimento Diario</th><th>Disponivel</th><th>Usado</th><th>Livre</th><th>Dias Restantes</th><th>Crescimento Mensal</th><th>Crescimento Anual</th></tr><tr>');
   DBMS_OUTPUT.PUT_LINE('<td>'|| :cres_diario_mb ||' MB </td>');
   DBMS_OUTPUT.PUT_LINE('<td>'|| :disp_mb ||' MB </td>');
   DBMS_OUTPUT.PUT_LINE('<td>'|| :used_mb ||' MB </td>');
end;
/
exec :free := :disp_mb - :used_mb;
prompt <td>
print :free
prompt MB </td>
Select '<td>'|| round( :free  / :cres_diario_mb )||'MB' , '<td>'|| round((:cres_diario_mb * 30)/1024), '<td>'|| round((:cres_diario_mb * 365)/1024)||'</td></tr></table>' from dual;
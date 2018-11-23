col owner for a20
SELECT trunc(SUM(bytes/1024/1024),2) AS "Tamanho em GB",
	owner
	FROM dba_segments 
GROUP BY owner 
ORDER BY 2; 
USE sysmon	 
GO 

/*** usp_OpenSessions *** 

This SP returns a list of connections, and the number of sessions associated  
with the connection 

*** by Doug Leidgen ***/ 

IF EXISTS (SELECT [name] from sys.sysobjects where [name] = 'usp_OpenSessions') 
	DROP PROC usp_OpenSessions 
GO 

CREATE PROC usp_OpenSessions 
AS 

select	 
		loginame 
		, count(*) 
from master..sysProcesses 
GROUP BY loginame 
order by loginame

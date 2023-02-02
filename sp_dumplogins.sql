use master
go

IF EXISTS(
select *
  from master.information_schema .routines
 where SPECIFIC_NAME = 'sp_dumpLogins' )
 drop procedure sp_dumpLogins

create proc sp_dumpLogins
AS
select db_name (), 'CREATE USER [' + name + '] FROM LOGIN [' + name + ']'
from sys .database_principals
where type in ('u', 's', 'g' )
and name NOT IN ('dbo', 'public', 'guest', 'sys', 'INFORMATION_SCHEMA')
 ; 

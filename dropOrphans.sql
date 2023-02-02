-- Script to find and generate drop statements for orphaned user accounts in a database
-- To get just a list of the users run the code in the CTE
with DropTheFuckers as
(
select DB_NAME() [database], name as [user_name], type_desc,default_schema_name,create_date,modify_date from sys.database_principals
where type in ('G','S','U')
--and authentication_type<>2 -- Use this filter only if you are running on SQL Server 2012 and major versions and you have "contained databases"
and [sid] not in ( select [sid] from sys.server_principals where type in ('G','S','U') )
and name not in ('dbo','guest','INFORMATION_SCHEMA','sys','MS_DataCollectorInternalUser')
)
select 'DROP USER ' + '['+[user_name]+']'
from DropTheFuckers
go

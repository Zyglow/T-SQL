/* These are the scripts I used for creating my monitoring table, and the code for populating the table */

create table DLUnusedIndexes ( 
		Obj_Name	varchar(120)	not null, 
		Index_Name	varchar(120)	null, 
		DbName		varchar(32)		not null, 
		User_Seek	int				null, 
		User_Scan	int				null, 
		User_Lookups	int			null, 
		User_updates	int			null, 
		Index_size		bigint		null, 
		Last_date		date		not null 
		) 
go 

create clustered index CIX_Name_DB_LastDate 
	on DLUnusedIndexes (Obj_Name, DbName, Last_date)


/* Used the following on sysmon.  Change DB if needed */
/* I should probably put this into an SP at some point    */

with indexage as
		(
			SELECT	OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME],
					I.[NAME] AS [INDEX NAME],
					D.[name] as [Database Name],
					USER_SEEKS,
					USER_SCANS,
					USER_LOOKUPS,
					USER_UPDATES,
					SUM(ps.[used_page_count]) * 8 AS [Index Size (KB)],
					GETDATE() as Last_date
				FROM SYS.DM_DB_INDEX_USAGE_STATS AS S
					INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID
					INNER JOIN SYS.DATABASES as D on D.database_id = S.database_id
					INNER JOIN sys.dm_db_partition_stats AS PS on PS.[object_id] = I.[object_id]
				WHERE OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
					AND S.database_id = DB_ID()
					and s.user_seeks = 0
					and s.user_scans = 0
					and s.user_lookups = 0
				GROUP BY	OBJECT_NAME(S.[OBJECT_ID]),
							I.[NAME],
							D.[name],
							USER_SEEKS,
							USER_SCANS,
							USER_LOOKUPS,
							USER_UPDATES
		)

insert into sysmon.[dbo].[DLUnusedIndexes]
select *
from indexage


/*
/* Agent job script */

exec sp_foreachdb 
@command = 'USE ?;

			with indexage as
			(
				SELECT	OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME],
						I.[NAME] AS [INDEX NAME],
						D.[name] as [Database Name],
						USER_SEEKS,
						USER_SCANS,
						USER_LOOKUPS,
						USER_UPDATES,
						SUM(ps.[used_page_count]) * 8 AS [Index Size (KB)],
						GETDATE() as Last_date
					FROM SYS.DM_DB_INDEX_USAGE_STATS AS S
						INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID
						INNER JOIN SYS.DATABASES as D on D.database_id = S.database_id
						INNER JOIN sys.dm_db_partition_stats AS PS on PS.[object_id] = I.[object_id]
					WHERE OBJECTPROPERTY(S.[OBJECT_ID],''IsUserTable'') = 1
						AND S.database_id = DB_ID()
						and s.user_seeks = 0
						and s.user_scans = 0
						and s.user_lookups = 0
					GROUP BY	OBJECT_NAME(S.[OBJECT_ID]),
								I.[NAME],
								D.[name],
								USER_SEEKS,
								USER_SCANS,
								USER_LOOKUPS,
								USER_UPDATES
			)

insert into sysmon.[dbo].[DLUnusedIndexes]
select *
from indexage'
*/

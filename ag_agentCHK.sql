/*	Name:		AG Agent Job Rollover 
	Author:		Doug Leidgen 
	Created:	12.12.2017 
	UPdated: 
	Desc:		This job detects the status of the current AG cluster  
				node and enables or disables SQL agent jobs based on  
				if the node is primary or secondary 
*/ 


DECLARE @PrimaryReplica sysname;  

		SELECT @PrimaryReplica = hags.primary_replica  
		FROM  
			sys.dm_hadr_availability_group_states hags 
			INNER JOIN sys.availability_groups ag ON ag.group_id = hags.group_id 
		WHERE 
			ag.name = 'agDMS';								-- AG name goes here 

-- If the server is primary then enable the following agent jobs 
		IF UPPER(@PrimaryReplica) =  UPPER(@@SERVERNAME)	 
			BEGIN 
					/* Place list of jobs to be enabled here */ 
					EXEC msdb.dbo.sp_update_job @job_name='Your job name',@enabled = 1 
					PRINT 'This serer is primary'	;				-- Logic check, comment out for production		 
			END 

-- If the server is secondary then disable the following agent jobs			 
		ELSE 													 
					/* Place list of jobs to be disabled here */ 
					EXEC msdb.dbo.sp_update_job @job_name='Your job name',@enabled = 0 
					PRINT 'This server is secondary'	;			-- Logic check, comment out for production 

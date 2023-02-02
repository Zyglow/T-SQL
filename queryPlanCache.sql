Select 
	QueryText = QueryTexts.text 
	,QueryPlan = QueryPlans.query_plan 
	,ExecutionCount = CachedPlans.usecounts 
	,ObjectType	= CachedPlans.objtype 
	,Size_KB = CachedPlans.size_in_bytes / 1024 
	,LastExecutionTime = last_execution_time 
FROM 
	sys.dm_exec_cached_plans AS CachedPlans 
Cross APPLY 
	sys.dm_exec_query_plan(plan_handle) as QueryPlans 
CROSS APPLY 
	sys.dm_exec_sql_text(plan_handle) AS QueryTexts 
INNER JOIN 
	sys.dm_exec_query_stats as QueryStats 
on 
	CachedPlans.plan_handle = QueryStats.plan_handle

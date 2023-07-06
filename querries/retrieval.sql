SELECT t."team_name" as team, COUNT(p."name") as project_count
FROM public."Teams" as t, public."TeamProject" as tp, public."Projects" as p
WHERE t."id" = tp."team_id" 
AND p."id" = tp."project_id"
GROUP BY team
ORDER BY team ASC

-- //==================================================================

SELECT e."first_name" as manager_name, p."name" as project
FROM public."Employees" as e, 
public."Projects" as p, 
public."Teams" as t, 
public."TeamProject" as tp,
public."Titles" as ti
WHERE e."team" = t."id" 
AND t."id" = tp."team_id" 
AND tp."project_id" = p."id" 
AND e."title_id" = ti."id" 
AND ti."name" LIKE '%Manager%'
AND (e."first_name" LIKE 'J%' OR e."first_name" LIKE 'D%')
ORDER BY manager_name ASC, project ASC

-- //==================================================================
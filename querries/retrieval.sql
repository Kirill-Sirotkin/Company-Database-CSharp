-- Retrieve the team names and their corresponding project count

SELECT t."team_name" as team, COUNT(p."name") as project_count
FROM public."Teams" as t, public."TeamProject" as tp, public."Projects" as p
WHERE t."id" = tp."team_id" 
AND p."id" = tp."project_id"
GROUP BY team
ORDER BY team ASC

-- //==================================================================
-- Retrieve the projects managed by the managers whose first name starts with "J" or "D"

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
-- Retrieve all the employees (both directly and indirectly) working under Andrew Martin

WITH RECURSIVE employeeList as
	(SELECT e.*, 1 as level
	FROM public."Employees" as e,
	public."Employees" as e2
	WHERE e."manager_id" = e2."id" 
	AND e2."first_name" = 'Andrew'
	AND e2."last_name" = 'Martin'
	
	UNION ALL
	 
	SELECT e2.*, EL."level" + 1
	FROM public."Employees" as e2
	INNER JOIN employeeList as EL
	ON e2."manager_id" = EL."id"
	)
SELECT EL."id", 
EL."first_name", 
EL."last_name", 
EL."hire_date",
EL."hourly_salary",
EL."title_id",
EL."manager_id",
EL."team"
FROM employeeList as EL

-- //==================================================================
-- Retrieve all the employees (both directly and indirectly) working under Robert Brown

WITH RECURSIVE employeeList as
	(SELECT e.*, 1 as level
	FROM public."Employees" as e,
	public."Employees" as e2
	WHERE e."manager_id" = e2."id" 
	AND e2."first_name" = 'Robert'
	AND e2."last_name" = 'Brown'
	
	UNION ALL
	 
	SELECT e2.*, EL."level" + 1
	FROM public."Employees" as e2
	INNER JOIN employeeList as EL
	ON e2."manager_id" = EL."id"
	)
SELECT EL."id", 
EL."first_name", 
EL."last_name", 
EL."hire_date",
EL."hourly_salary",
EL."title_id",
EL."manager_id",
EL."team"
FROM employeeList as EL

-- //==================================================================
-- Retrieve the average hourly salary for each title

SELECT t."team_name" as team, AVG(e."hourly_salary") as average_salary
FROM public."Employees" as e,
public."Teams" as t
WHERE e."team" = t."id"
GROUP BY t."team_name"
ORDER BY average_salary DESC

-- //==================================================================
-- Retrieve the employees who have a higher hourly salary than their respective team's average hourly salary

SELECT e.*, res."average_salary"
FROM public."Employees" as e, (
	SELECT t."id" as team, AVG(e."hourly_salary") as average_salary
	FROM public."Employees" as e,
	public."Teams" as t
	WHERE e."team" = t."id"
	GROUP BY t."id") as res
WHERE e."team" = res."team"
AND e."hourly_salary" > res."average_salary"

-- //==================================================================
-- Retrieve the projects that have more than 3 teams assigned to them

SELECT p.*, COUNT(tp."team_id") as team_count
FROM public."Projects" as p,
public."TeamProject" as tp
WHERE p."id" = tp."project_id"
GROUP BY  p."id"
HAVING COUNT(tp."team_id") > 3
ORDER BY p."id" ASC

-- //==================================================================
-- Retrieve the total hourly salary expense for each team

SELECT t.*, SUM(e."hourly_salary") as expense
FROM public."Employees" as e,
public."Teams" as t
WHERE e."team" = t."id"
GROUP BY t."id"
ORDER BY t."id" ASC
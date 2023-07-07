create or replace function track_working_hours(
	employee_id integer, 
	project_id integer, 
	total_hours integer)
returns void as $$
declare
	e_id integer := employee_id;
	p_id integer := project_id;
	t_hours integer := total_hours;
begin
	if not exists (select 1 from public."Employees" as em where em."id" = e_id) 
	then raise exception 'Employee does not exist';
	end if;
	if not exists (select 1 from public."Projects" as pr where pr."id" = p_id) 
	then raise exception 'Project does not exist';
	end if;
	if exists (select * from public."HourTracking" as ht
			  where ht."employee_id" = e_id
			  And ht."project_id" = p_id)
		then update public."HourTracking" as ht set total_hours = t_hours 
		where ht."employee_id" = e_id 
		and ht."project_id" = p_id;
	else
		insert into public."HourTracking" values (e_id, p_id, t_hours);
	end if;
end;
$$ language plpgsql

-- //==================================================================

create or replace function create_project_with_teams(
	project_name varchar, 
	client_name varchar, 
	start_date date,
	deadline_date date,
	assigned_team integer[])
returns void as $$
declare
	p_name varchar := project_name;
	c_name varchar := client_name;
	s_date date := start_date;
	dl_date date := deadline_date;
	teams integer[] := assigned_team;
	team integer;
	new_id integer;
begin
	if s_date > dl_date 
	then raise exception 'Deadline earlier than start date';
	end if;
	foreach team in array teams 
	loop
		if not exists (select 1 from public."Teams" as tm
					  where tm."id" = team)
		then raise exception 'One or more teams does not exist';
		end if;
	end loop;
	new_id := (select max(p."id") from public."Projects" as p) + 1;
	insert into public."Projects" values (new_id, p_name, c_name, s_date, dl_date);
	foreach team in array teams 
	loop
		insert into public."TeamProject" values (team, new_id);
	end loop;
end;
$$ language plpgsql
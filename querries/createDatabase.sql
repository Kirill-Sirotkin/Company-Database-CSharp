CREATE TABLE IF NOT EXISTS public."Titles"
(
    id integer NOT NULL DEFAULT nextval('"Titles_id_seq"'::regclass),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Titles_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Titles"
    OWNER to postgres;

-- //==================================================================

CREATE TABLE IF NOT EXISTS public."Teams"
(
    id integer NOT NULL DEFAULT nextval('"Teams_id_seq"'::regclass),
    team_name character varying COLLATE pg_catalog."default" NOT NULL,
    location character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Teams_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Teams"
    OWNER to postgres;

-- //==================================================================

CREATE TABLE IF NOT EXISTS public."Projects"
(
    id integer NOT NULL DEFAULT nextval('"Projects_id_seq"'::regclass),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    client character varying COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL,
    deadline date NOT NULL,
    CONSTRAINT "Projects_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Projects"
    OWNER to postgres;

-- //==================================================================

CREATE TABLE IF NOT EXISTS public."TeamProject"
(
    team_id integer NOT NULL,
    project_id integer NOT NULL,
    CONSTRAINT project_id FOREIGN KEY (project_id)
        REFERENCES public."Projects" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT team_id FOREIGN KEY (team_id)
        REFERENCES public."Teams" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."TeamProject"
    OWNER to postgres;

-- //==================================================================

CREATE TABLE IF NOT EXISTS public."Employees"
(
    id integer NOT NULL DEFAULT nextval('"Employees_id_seq"'::regclass),
    first_name character varying COLLATE pg_catalog."default",
    last_name character varying COLLATE pg_catalog."default",
    hire_date date,
    hourly_salary numeric,
    title_id integer,
    manager_id integer,
    team integer,
    CONSTRAINT "Employees_pkey" PRIMARY KEY (id),
    CONSTRAINT manager_id FOREIGN KEY (manager_id)
        REFERENCES public."Employees" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT title_id FOREIGN KEY (title_id)
        REFERENCES public."Titles" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Employees"
    OWNER to postgres;

-- //==================================================================

CREATE TABLE IF NOT EXISTS public."HourTracking"
(
    employee_id integer NOT NULL,
    project_id integer NOT NULL,
    total_hours integer NOT NULL,
    CONSTRAINT employee_id FOREIGN KEY (employee_id)
        REFERENCES public."Employees" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT project_id FOREIGN KEY (project_id)
        REFERENCES public."Projects" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."HourTracking"
    OWNER to postgres;

-- //==================================================================

\copy public.\"Titles\" (name) 
FROM 'D:/Programming/Integrify/Backend/Assignment 16/fs15_16_company-database/data/titles.csv' 
DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

-- //==================================================================

\copy public.\"Teams\" (team_name, location) 
FROM 'D:/Programming/Integrify/Backend/Assignment 16/fs15_16_company-database/data/teams.csv' 
DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

-- //==================================================================

\copy public.\"Projects\" (name, client, start_date, deadline) 
FROM 'D:/Programming/Integrify/Backend/Assignment 16/fs15_16_company-database/data/projects.csv' 
DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

-- //==================================================================

\copy public.\"TeamProject\" (team_id, project_id) 
FROM 'D:/Programming/Integrify/Backend/Assignment 16/fs15_16_company-database/data/team_project.csv' 
DELIMITER ',' CSV HEADER QUOTE '\"' ESCAPE '''';""

-- //==================================================================

\copy public.\"Employees\" (first_name, last_name, hire_date, hourly_salary, title_id, manager_id, team) 
FROM 'D:/Programming/Integrify/Backend/Assignment 16/fs15_16_company-database/data/employees.csv' 
DELIMITER ',' CSV HEADER QUOTE '\"' NULL 'NULL' ESCAPE '''';""

-- //==================================================================

\copy public.\"HourTracking\" (employee_id, project_id, total_hours) 
FROM 'D:/Programming/Integrify/Backend/Assignment 16/fs15_16_company-database/data/hour_tracking.csv' 
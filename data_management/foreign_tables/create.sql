-- ADD NEEDED EXTENSION 
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- CREATE SERVER

CREATE SERVER web_server 
FOREIGN DATA WRAPPER postgres_fdw 
OPTIONS (
    host 'remote_host',    -- e.g., 'localhost' for same-server setup
    dbname 'remote_db',    -- e.g., 'markets'
    port '5432'
);

-- CREATE USER MAPPING

CREATE USER MAPPING FOR current_user 
SERVER web_server 
OPTIONS (
    user 'remote_user',       -- e.g., 'postgres'
    password 'remote_password'
);

-- CREATE FOREIGN TABLE

CREATE FOREIGN TABLE public.research_group (
    id bigint NOT NULL,
    name varchar(255) NOT NULL,
    shortname varchar(25) NOT NULL,
    email varchar(254),
    website varchar(150),
    image varchar(100),
    geom geometry(Point, 4326),
    organization_id bigint NOT NULL
) SERVER web_server 
OPTIONS (
    schema_name 'remote_schema',   -- e.g., 'main'
    table_name 'remote_table'      -- e.g., 'research_group'
);

-- ALTER FOREIGN SERVER OPTIONS
ALTER SERVER web_server OPTIONS (SET host 'XX.XXX.XX.X');
ALTER SERVER web_server OPTIONS (SET dbname 'new_db');
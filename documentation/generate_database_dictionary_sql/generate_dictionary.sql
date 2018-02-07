SELECT report as "# DATABASE REPORT: eurodeer_db SCHEMAS and TABLES" -- The name of the column is used as main title
FROM 
-- I generate the list of schemas, tables and fields with their comments (excluding some elements, e.g. tables in working schema)
-- I format the text in MD
-- I union the three elements and I order by schema, table and columns position

-- TABLES
(SELECT table_name tablex, table_schema schemax, relkind, 0 as ordex, 
'### ' || case when relkind = 'r' then 'TABLE: ' when relkind = 'v' then 'VIEW: ' when relkind = 'e' then 'EXTERNAL TABLE: ' end || replace(table_schema,'_','\_') || '.' || replace(table_name,'_','\_')  || E'  \n' || 
replace(coalesce(obj_description(oid),''),'_','\_') || E'  \n\n' || case when relkind = 'r' then E'#### COLUMNS \n\n' else '' end  as report
FROM information_schema.tables left join (select relkind, pg_class.oid, n.nspname, relname from pg_class JOIN pg_catalog.pg_namespace n ON n.oid = pg_class.relnamespace) x
on table_name= relname and table_schema = x.nspname
WHERE table_schema in (select nspname from pg_catalog.pg_namespace WHERE nspname !~ '^pg_' AND nspname not in ( 'information_schema','public','temp', 'activity_data_raw') and nspname not like 'ws_%')

union

-- SCHEMAS
select '' tablex, nspname schemax,'z' as relkind, 0 as ordex, '## SCHEMA: ' ||  replace(nspname,'_','\_') || E'  \n**' || obj_description(oid, 'pg_namespace')|| E'**  \n'
from pg_catalog.pg_namespace WHERE nspname !~ '^pg_' AND nspname <> 'information_schema' and nspname not like 'ws_%' 

union

-- COLUMNS
SELECT  columns.table_name tablex, columns.table_schema schemax,x.relkind, ordinal_position,
'* **' || replace(column_name,'_','\_') || '** ['||data_type ||']: ' || case when col_description(oid, ordinal_position) is not Null then '*' || 
replace(coalesce(col_description(oid, ordinal_position),''),'_','\_') || E'* ' else E'' end  as report
FROM 
   information_schema.columns, 
   information_schema.tables, 
   (SELECT n.nspname, pg_class.oid, relname, relkind FROM pg_class JOIN pg_catalog.pg_namespace n ON n.oid = pg_class.relnamespace) x
WHERE tables.table_schema in (select nspname from pg_catalog.pg_namespace WHERE nspname !~ '^pg_' AND nspname not in ( 'information_schema','public','temp', 'activity_data_raw') and nspname not like 'ws_%')
 and  columns.table_schema = tables.table_schema and x.nspname = columns.table_schema and tables.table_name= x.relname and tables.table_name= columns.table_name and x.relkind in ('r')
) q
-- I order by schema (with a predefined order) then by table name (first table, then view and external tables) and by column position
-- It could simply be schemax, relkind, tablex, ordex, but I want to decide the order of the schemas
order by 
schemax = 'main' DESC,
schemax = 'lu_tables' DESC,
schemax = 'env_data' DESC,
schemax = 'env_data_ts' DESC,
schemax = 'analysis' DESC,
schemax = 'tools' DESC,
schemax = 'activity_data_raw' DESC,
schemax = 'temp' DESC,
schemax = 'public' DESC,
relkind = 'z' DESC, 
relkind = 'r' DESC, 
relkind = 'e' DESC, 
relkind = 'v' DESC,
tablex, 
ordex

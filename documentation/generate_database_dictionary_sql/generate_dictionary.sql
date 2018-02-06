select report as "# DATABASE REPORT: eurodeer_db SCHEMAS and TABLES" from 
(SELECT table_name tablex, table_schema schemax, relkind, 0 as ordex, 
'### ' || case when relkind = 'r' then 'TABLE: ' when relkind = 'v' then 'VIEW: ' when relkind = 'e' then 'EXTERNAL TABLE: ' end || replace(table_schema,'_','\_') || '.' || replace(table_name,'_','\_')  || E'  \n' || 
replace(coalesce(obj_description(oid),''),'_','\_') || E'  \n\n' || case when relkind = 'r' then E'#### COLUMNS \n\n' else '' end  as report
FROM information_schema.tables left join (select relkind, pg_class.oid, n.nspname, relname from pg_class JOIN pg_catalog.pg_namespace n ON n.oid = pg_class.relnamespace) x
on table_name= relname and table_schema = x.nspname
WHERE table_schema in (select nspname from pg_catalog.pg_namespace WHERE nspname !~ '^pg_' AND nspname not in ( 'information_schema','public','temp', 'activity_data_raw') and nspname not like 'ws_%')

union
select '' tablex, nspname schemax,'z' as relkind, 0 as ordex, '## SCHEMA: ' ||  replace(nspname,'_','\_') || E'  \n**' || obj_description(oid, 'pg_namespace')|| E'**  \n'
from pg_catalog.pg_namespace WHERE nspname !~ '^pg_' AND nspname <> 'information_schema' and nspname not like 'ws_%' 

union
SELECT  columns.table_name tablex, columns.table_schema schemax,pg_class.relkind, ordinal_position,
'* **' || replace(column_name,'_','\_') || '** ['||data_type ||'] ' || case when col_description(oid, ordinal_position) is not Null then '*' || 
replace(coalesce(col_description(oid, ordinal_position),''),'_','\_') || E'* ' else E'' end  as report
FROM information_schema.columns, information_schema.tables, pg_class
WHERE tables.table_schema in (select nspname from pg_catalog.pg_namespace WHERE nspname !~ '^pg_' AND nspname not in ( 'information_schema','public','temp', 'activity_data_raw') and nspname not like 'ws_%')
 and  columns.table_schema = tables.table_schema and tables.table_name= relname and tables.table_name= columns.table_name and pg_class.relkind in ('r')
) q
order by 
schemax = 'main' DESC,
schemax = 'lu_tables' DESC,
schemax = 'env_data' DESC,
schemax = 'env_data_ts' DESC,
schemax = 'analysis' DESC,
schemax = 'activity_data_raw' DESC,
schemax = 'tools' DESC,
schemax = 'temp' DESC,
schemax = 'public' DESC,
relkind = 'z' DESC, 
relkind = 'r' DESC, 
relkind = 'e' DESC, 
relkind = 'v' DESC,
tablex, 
ordex
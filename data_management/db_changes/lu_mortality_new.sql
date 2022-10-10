create table lu_tables.lu_mortality_new (mortality_code integer primary key, mortality_name text, mortality_description text);

comment ON column lu_tables.lu_mortality_new.mortality_code is 'The mortality code is the code create for a specific class of mortality';
comment ON column lu_tables.lu_mortality_new.mortality_name is 'The mortality name is the short description of mortality of animal';
comment ON column lu_tables.lu_mortality_new.mortality_description is 'The mortality description is the long description of mortality of animal';

copy lu_tables.lu_mortality_new from '/tmp/lu_mortality_new.csv' with csv header delimiter '|';

alter table main.animals add column mortality_code_new integer;
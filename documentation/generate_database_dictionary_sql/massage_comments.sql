-- MASSAGE COMMENTS ON COLUMNS

-- REMOVE SPACE AS FIRST CHARACTER OF A COMMENT

SELECT 'COMMENT ON COLUMN ' || columns.table_schema || '.' || columns.table_name || '.' ||column_name ||' IS ''' || substring(col_description(oid, ordinal_position), 2,length(col_description(oid, ordinal_position))) ||''';'
FROM information_schema.columns, information_schema.tables, pg_class
WHERE  columns.table_schema = tables.table_schema and tables.table_name= relname and tables.table_name= columns.table_name 
and col_description(oid, ordinal_position) is not null and left(col_description(oid, ordinal_position),1) = ' ';

-- REMOVE SPACE AS FIRST CHARACTER OF A COMMENT

SELECT 'COMMENT ON COLUMN ' || columns.table_schema || '.' || columns.table_name || '.' ||column_name ||' IS ''' || substring(col_description(oid, ordinal_position), 1,length(col_description(oid, ordinal_position))-1) ||''';'
FROM information_schema.columns, information_schema.tables, pg_class
WHERE  columns.table_schema = tables.table_schema and tables.table_name= relname and tables.table_name= columns.table_name 
and col_description(oid, ordinal_position) is not null and right(col_description(oid, ordinal_position),1) = ' ';

-- ADD '.' AT THE END OF EACH COMMENT (IF NOT THERE ALREADY)]

SELECT 'COMMENT ON COLUMN ' || columns.table_schema || '.' || columns.table_name || '.' ||column_name ||' IS ''' || col_description(oid, ordinal_position)||'.'';'
FROM information_schema.columns, information_schema.tables, pg_class
WHERE  columns.table_schema = tables.table_schema and tables.table_name= relname and tables.table_name= columns.table_name 
and col_description(oid, ordinal_position) is not null and right(col_description(oid, ordinal_position),1) not in ('.',';');

-- SET FIRST CHARACTER AS UPPERCASE

SELECT 'COMMENT ON COLUMN ' || columns.table_schema || '.' || columns.table_name || '.' ||column_name ||' IS ''' || 
upper(SUBSTRING(col_description(oid, ordinal_position), 1, 1)) || substring(col_description(oid, ordinal_position),2,length(col_description(oid, ordinal_position))) ||''';'
FROM information_schema.columns, information_schema.tables, pg_class
WHERE  columns.table_schema = tables.table_schema and tables.table_name= relname and tables.table_name= columns.table_name 
and col_description(oid, ordinal_position) is not null and
SUBSTRING(col_description(oid, ordinal_position) FROM 1 FOR 1) != upper(SUBSTRING(col_description(oid, ordinal_position) FROM 1 FOR 1));
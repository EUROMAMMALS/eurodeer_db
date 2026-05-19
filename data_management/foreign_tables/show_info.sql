-- SHOW FOREIGN server

SELECT 
    srvname as name, 
    srvowner::regrole as owner, 
    fdwname as wrapper, 
    srvoptions as options
FROM pg_foreign_server
JOIN pg_foreign_data_wrapper w ON w.oid = srvfdw;

-- or you can use

SELECT * FROM information_schema.foreign_servers;

-- or you can use \des+

-- SHOW user mapping for FOREIGN server

SELECT
  umid,
  srvname,
  usename,
  umuser
FROM pg_user_mappings;

-- SHOW FOREIGN TABLES

SELECT * FROM information_schema.foreign_tables;
/*
======================================================
Creating Schemas in the Database
======================================================

Script's Purpose:
    This script creates a database named 'datawarehouse' after checking its existence.
    Besides that, it sets up three schemas - 'bronze', 'silver', and 'gold' - schemas within the database.
*/

-- Drop the 'datawarehouse' database if exists
DROP DATABASE IF EXISTS datawarehouse;

-- Recreate the 'datawarehouse' database
CREATE DATABASE datawarehouse
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_Europe.1252'
    LC_CTYPE = 'English_Europe.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


-- Create Schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'Bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Performs the `Full Load` in the form of COPY command to load data from CSV files to Bronze Layer's tables.

Parameters:
    The  stored procedure doesn't accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$

DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP; 
    batch_end_time TIMESTAMP;
BEGIN
    batch_start_time:= CURRENT_TIMESTAMP;
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '=========================================';


    RAISE NOTICE '-----------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '-----------------------------------------';

    start_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
        COPY bronze.crm_cust_info
        FROM 'D:\SQL_Projects\SQL_DWH_Project\datasets\source_crm\cust_info.csv'
        DELIMITER ','
        CSV HEADER;
        RAISE NOTICE 'Rows inserted: %', (SELECT COUNT(*) FROM bronze.crm_cust_info);
        end_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
        RAISE NOTICE '-----------------------------------------';


    start_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
        COPY bronze.crm_prd_info
        FROM 'D:\SQL_Projects\SQL_DWH_Project\datasets\source_crm\prd_info.csv'
        DELIMITER ','
        CSV HEADER;
        RAISE NOTICE 'Rows inserted: %', (SELECT COUNT(*) FROM bronze.crm_prd_info);
        end_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
        RAISE NOTICE '-----------------------------------------';


    start_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
        COPY bronze.crm_sales_details
        FROM 'D:\SQL_Projects\SQL_DWH_Project\datasets\source_crm\sales_details.csv'
        DELIMITER ','
        CSV HEADER;
        RAISE NOTICE 'Rows inserted: %', (SELECT COUNT(*) FROM bronze.crm_sales_details);
        end_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
        RAISE NOTICE '-----------------------------------------';

    RAISE NOTICE '-----------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '-----------------------------------------';

    start_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
        COPY bronze.erp_cust_az12
        FROM 'D:\SQL_Projects\SQL_DWH_Project\datasets\source_erp\CUST_AZ12.csv'
        DELIMITER ','
        CSV HEADER;
        RAISE NOTICE 'Rows inserted: %', (SELECT COUNT(*) FROM bronze.erp_cust_az12);
        end_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
        RAISE NOTICE '-----------------------------------------';

    start_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
        COPY bronze.erp_loc_a101
        FROM 'D:\SQL_Projects\SQL_DWH_Project\datasets\source_erp\LOC_A101.csv'
        DELIMITER ','
        CSV HEADER;
        RAISE NOTICE 'Rows inserted: %', (SELECT COUNT(*) FROM bronze.erp_loc_a101);
        end_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
        RAISE NOTICE '-----------------------------------------';

    start_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        COPY bronze.erp_px_cat_g1v2
        FROM 'D:\SQL_Projects\SQL_DWH_Project\datasets\source_erp\PX_CAT_G1V2.csv'
        DELIMITER ','
        CSV HEADER;
        RAISE NOTICE 'Rows inserted: %', (SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2);
        end_time:= CURRENT_TIMESTAMP;
        RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));
        RAISE NOTICE '-----------------------------------------';

    batch_end_time:= CURRENT_TIMESTAMP;
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'Bronze Layer Loading is Completed';
    RAISE NOTICE 'Total Load Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '=========================================';

EXCEPTION
    WHEN others THEN
    RAISE NOTICE '=========================================';
    RAISE NOTICE 'ERROR OCCURED DURING LOADING BRONZE LAYER';
    RAISE NOTICE 'Error Message: %', SQLERRM;
    RAISE NOTICE 'Error State: %', SQLSTATE;
    RAISE NOTICE '=========================================';

END; 
$$;

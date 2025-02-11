-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- Checking For Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Checking for Unwanted Spaces
-- Expectation: No Results
SELECT
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

--Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- Final Look
SELECT *
FROM silver.crm_cust_info;

-- ====================================================================
-- Checkinging 'silver.crm_prd_info'
-- ====================================================================

--  Checkinging For Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Checking for Unwanted Spaces
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Checking for NULLs or Negative Values
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Data Standardization & Consistency
SELECT DISTINCT prd_line 
FROM silver.crm_prd_info;

-- Checking for Invalid Date Orders (End Date < Start Date)
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Final Look
SELECT *
FROM silver.crm_prd_info;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- Checking Invalid Dates
-- Expectation: No Results
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 OR LENGTH(sls_due_dt::TEXT) != 8 OR 
sls_due_dt > 20500101 OR sls_due_dt < 19000101;

-- Checking Invalid Date Orders (Order Date > Ship Date or Due Date)
-- Expectation: No Results
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;


-- Checking Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values mustn't be NULL, 0, or Negative

SELECT
    sls_sales, 
    sls_quantity, 
    sls_price
FROM silver.crm_sales_details
WHERE 
    sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
    OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Final Look
SELECT * FROM silver.crm_sales_details;

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

-- Identifying Out-of-Range Dates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > NOW();

-- Data Standardization & Consistency
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;

-- Final Look
SELECT * FROM silver.erp_cust_az12;

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

-- Data Standardization & Consistency
SELECT DISTINCT 
    cntry
FROM silver.erp_loc_a101;

-- Final Look
SELECT * FROM silver.erp_loc_a101;

-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================

-- Checking for Unwanted Spaces
-- Expectation: No Results

SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Checking Data Standardization & Consistency
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;

--Final Look
SELECT * FROM silver.erp_px_cat_g1v2;
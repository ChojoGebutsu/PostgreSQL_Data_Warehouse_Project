/*
===============================================================================
DDL Script: Create Gold Layer Views
===============================================================================
Script Purpose:
This script is designed to create views for the Gold layer in the data warehouse. The Gold layer represents the final, business-ready dimension and fact tables structured in a Star Schema.

Each view is responsible for performing necessary transformations and combining data from the Silver layer to produce clean, enriched datasets that are optimized for analytics and reporting.

Usage:
These views can be directly queried by analysts, reporting tools, or downstream applications to access the final, refined data for business intelligence and decision-making.
===============================================================================
*/



-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key, -- Surrogate key 
    ci.cst_id AS customer_id, 
    ci.cst_key AS customer_number, 
    ci.cst_firstname AS first_name, 
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status, 
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the primary source of gender
        ELSE COALESCE(ca.gen, 'n/a') -- Fall back to ERP if CRM is not available
    END AS gender, 
    ca.bdate AS birth_date,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id AS product_id, 
    pn.prd_key AS product_number, 
    pn.prd_nm AS product_name, 
    pn.cat_id AS category_id, 
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost, 
    pn.prd_line AS product_line, 
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Filtering out all historical data;

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================

CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number, 
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date, 
    sd.sls_ship_dt AS shipping_date, 
    sd.sls_due_dt AS due_date, 
    sd.sls_sales AS sales_amount, 
    sd.sls_quantity AS quantity, 
    sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers AS cu
    ON sd.sls_cust_id = cu.customer_id;


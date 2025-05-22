-- Quality checks for data consistency and correctness in Silver layer tables

-- Checks on "Silver".crm_cust_info
-- Check for NULLs or duplicates in primary key
SELECT cst_id, COUNT(*) 
FROM "Silver".crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted leading/trailing spaces in key field
SELECT cst_key 
FROM "Silver".crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Review distinct values in marital status for standardization
SELECT DISTINCT cst_marital_status 
FROM "Silver".crm_cust_info;

-- Checks on "Silver".crm_prd_info
-- Check for NULLs or duplicates in primary key
SELECT prd_id, COUNT(*) 
FROM "Silver".crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces in product name
SELECT prd_nm 
FROM "Silver".crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULL or negative values in product cost
SELECT prd_cost 
FROM "Silver".crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Review distinct product lines for consistency
SELECT DISTINCT prd_line 
FROM "Silver".crm_prd_info;

-- Check for invalid date order: end date before start date
SELECT * 
FROM "Silver".crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Checks on "Bronze".crm_sales_details
-- Validate sales due dates for reasonable ranges and formats
SELECT NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM "Bronze".crm_sales_details
WHERE sls_due_dt <= 0 
    OR LENGTH(CAST(sls_due_dt AS TEXT)) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Checks on "Silver".crm_sales_details
-- Check for invalid date order: order date after ship or due date
SELECT * 
FROM "Silver".crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check sales amount matches quantity * price and no null/negative values
SELECT DISTINCT sls_sales, sls_quantity, sls_price 
FROM "Silver".crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Checks on "Silver".erp_cust_az12
-- Identify birthdates outside reasonable range
SELECT DISTINCT bdate 
FROM "Silver".erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > CURRENT_DATE;

-- Review distinct gender values for consistency
SELECT DISTINCT gen 
FROM "Silver".erp_cust_az12;

-- Checks on "Silver".erp_loc_a101
-- Review distinct country values for consistency
SELECT DISTINCT cntry 
FROM "Silver".erp_loc_a101
ORDER BY cntry;

-- Checks on "Silver".erp_px_cat_g1v2
-- Check for unwanted spaces in category fields
SELECT * 
FROM "Silver".erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Review distinct maintenance values for consistency
SELECT DISTINCT maintenance 
FROM "Silver".erp_px_cat_g1v2;

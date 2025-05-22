/*
===============================================================================
Procedure: silver_proc
what it does ?:
    Loads data from Bronze to Silver layer by:
        - Truncating existing Silver tables
        - Transforming and inserting cleansed data from Bronze tables

Details:
    - Standardizes fields like gender, marital status, product line, etc.
    - Ensures data quality by applying filters, formatting, and calculations
    - Loads the latest records where applicable

how to call ?:
    CALL "Silver".silver_proc(); -- silver is schema here
===============================================================================
*/

CREATE OR REPLACE PROCEDURE "Silver".silver_proc()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Table-1';
    /****** Truncate and Load crm_cust_info into Silver ******/
    TRUNCATE TABLE "Silver".crm_cust_info;

    INSERT INTO "Silver".crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,         
        cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END AS cst_marital_status,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'n/a'
        END AS cst_gndr,
        cst_create_date
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last 
        FROM "Bronze".crm_cust_info
        WHERE cst_id IS NOT NULL
    ) AS ranked
    WHERE flag_last = 1;

    RAISE NOTICE 'Table-2';
    /****** Truncate and Load crm_prd_info into Silver ******/
    TRUNCATE TABLE "Silver".crm_prd_info;

    INSERT INTO "Silver".crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, 
        SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
        prd_nm,     
        COALESCE(prd_cost, 0) AS prd_cost,
        CASE UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,
        CAST(prd_start_dt AS DATE) AS prd_start_dt,
        CAST(
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key 
                ORDER BY prd_start_dt
            ) - INTERVAL '1 day'
        AS DATE) AS prd_end_dt
    FROM "Bronze".crm_prd_info;

    RAISE NOTICE 'Table-3';
    /****** Truncate and Load crm_sales_details into Silver ******/
    TRUNCATE TABLE "Silver".crm_sales_details;

    INSERT INTO "Silver".crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE 
            WHEN sls_order_dt = 0 OR LENGTH(CAST(sls_order_dt AS TEXT)) != 8 THEN NULL
            ELSE TO_DATE(CAST(sls_order_dt AS TEXT), 'YYYYMMDD')
        END AS sls_order_dt,
        CASE 
            WHEN sls_ship_dt = 0 OR LENGTH(CAST(sls_ship_dt AS TEXT)) != 8 THEN NULL
            ELSE TO_DATE(CAST(sls_ship_dt AS TEXT), 'YYYYMMDD')
        END AS sls_ship_dt,
        CASE 
            WHEN sls_due_dt = 0 OR LENGTH(CAST(sls_due_dt AS TEXT)) != 8 THEN NULL
            ELSE TO_DATE(CAST(sls_due_dt AS TEXT), 'YYYYMMDD')
        END AS sls_due_dt,
        CASE 
            WHEN sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) OR sls_sales IS NULL 
            THEN (sls_quantity * ABS(sls_price))
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE 
            WHEN sls_price <= 0 OR sls_price IS NULL
            THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END AS sls_price
    FROM "Bronze".crm_sales_details;

    RAISE NOTICE 'Table-4';
    /****** Truncate and Load erp_cust_az12 into Silver ******/
    TRUNCATE TABLE "Silver".erp_cust_az12;

    INSERT INTO "Silver".erp_cust_az12 (
        cid,
        bdate,
        gen
    )
    SELECT 
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
            ELSE cid
        END AS cid,
        CASE 
            WHEN bdate > CURRENT_DATE THEN NULL
            ELSE bdate
        END AS bdate,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            ELSE 'n/a'
        END AS gen
    FROM "Bronze".erp_cust_az12;

    RAISE NOTICE 'Table-5';
    /****** Truncate and Load erp_loc_a101 into Silver ******/
    TRUNCATE TABLE "Silver".erp_loc_a101;

    INSERT INTO "Silver".erp_loc_a101 (
        cid,
        cntry
    )
    SELECT 
        REPLACE(cid, '-', '') AS cid,
        CASE 
            WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
            WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
            WHEN UPPER(TRIM(cntry)) = '' OR cntry IS NULL THEN 'n/a'
            ELSE cntry
        END AS cntry
    FROM "Bronze".erp_loc_a101;

    RAISE NOTICE 'Table-6';
    /****** Truncate and Load erp_px_cat_g1v2 into Silver ******/
    TRUNCATE TABLE "Silver".erp_px_cat_g1v2;

    INSERT INTO "Silver".erp_px_cat_g1v2 (
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM "Bronze".erp_px_cat_g1v2;
END;
$$;

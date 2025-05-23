/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Why:
    Creates 3 Gold layer views (Star Schema- customer dimension - product dimension and fact sales data ) 
    by transforming and combining data from 
    Silver layer (all tables -6 ) into clean, enriched, business-ready datasets.

How it can be used:
    we can Query these views for analytics and reporting.
===============================================================================
*/
-------view 1 
  
DROP VIEW IF EXISTS "Gold".customer_dimension;
Create view "Gold".customer_dimension as

Select 
       ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
		ci.cst_id as customer_id,
        ci.cst_key as customer_number,
        ci.cst_firstname as first_name,
        ci.cst_lastname as last_name,
        ci.cst_marital_status as marital_status,
		la.cntry as country,
        case when ci.cst_gndr != 'n/a' then ci.cst_gndr --- CRM data priority for customer information 
		     else coalesce(ca.gen,'n/a')
		end as gender,
        ci.cst_create_date as create_date,
		ca.bdate as birthdate				
from 
"Silver".crm_cust_info ci
left join
"Silver".erp_cust_az12 ca
on ci.cst_key = ca.cid
left join
"Silver".erp_loc_a101 la
on ci.cst_key = la.cid;


------- view 2

DROP VIEW IF EXISTS "Gold".product_dimension;
CREATE VIEW "Gold".product_dimension AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS Product_cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM "Silver".crm_prd_info pn
LEFT JOIN "Silver".erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; -- Filter out all historical data


--------- view -3
  
DROP VIEW IF EXISTS "Gold".fact_sales;
CREATE VIEW "Gold".fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM "Silver".crm_sales_details sd
LEFT JOIN "Gold".product_dimension pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN "Gold".customer_dimension cu
    ON sd.sls_cust_id = cu.customer_id;

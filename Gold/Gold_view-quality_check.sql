-- Checking '"Gold".customer_dimension'
-- Check for Uniqueness of Customer Key in "Gold".customer_dimension

SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM "Gold".customer_dimension
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- Checking '"Gold".product_dimension'
-- Check for Uniqueness of Product Key in "Gold".product_dimension

SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM "Gold".product_dimension
GROUP BY product_key
HAVING COUNT(*) > 1;


-- Checking "Gold".fact_sales
-- Check the data model connectivity between fact and dimensions

SELECT * 
FROM "Gold".fact_sales f
LEFT JOIN "Gold".customer_dimension c
    ON c.customer_key = f.customer_key
LEFT JOIN "Gold".product_dimension p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;

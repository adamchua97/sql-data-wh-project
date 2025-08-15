/*

DATA CLEANING AND INSPECTION QUERIES
	- Perform on Bronze layer BEFORE transformations
	- Perform again on Silver layer AFTER to ensure data cleanliness

*/

/*
CHECK FOR INVALID DATES:

- Check date boundaries
	- Make sure there's no date in the distant future or past
- Check to make sure that order date is earlier than shipping or due date
	- Inspect if there's any order date that is greater (later) than shipping or due date


-- Dates in the sales details table are in integer form
*/

SELECT 
	NULLIF(sls_order_dt, 0) sls_order_dt  -- Change to NULL if there's 0
FROM bronze.crm_sales_details
WHERE 
	sls_order_dt <= 0 OR
	LEN(sls_order_dt) != 8 OR -- check if date digits go past 8-digit values
	sls_order_dt > 20500101 OR
	sls_order_dt < 19000101;



SELECT 
	NULLIF(sls_ship_dt, 0) sls_ship_dt  -- Change to NULL if there's 0
FROM bronze.crm_sales_details
WHERE 
	sls_ship_dt <= 0 OR
	LEN(sls_ship_dt) != 8 OR -- check if date digits go past 8-digit values
	sls_ship_dt > 20500101 OR
	sls_ship_dt < 19000101;


SELECT 
	NULLIF(sls_due_dt, 0) sls_due_dt  -- Change to NULL if there's 0
FROM bronze.crm_sales_details
WHERE 
	sls_due_dt <= 0 OR
	LEN(sls_due_dt) != 8 OR -- check if date digits go past 8-digit values
	sls_due_dt > 20500101 OR
	sls_due_dt < 19000101;


SELECT *
FROM bronze.crm_sales_details
WHERE 
	sls_order_dt > sls_ship_dt OR
	sls_order_dt > sls_due_dt;


/* 
Business Rules

	>> Sales = Quantity * Price
	>> Negatives, zeroes, nulls are not allowed!
*/

-- Check Data Consistency: Between Sales, Quantity and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero or negative.

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE
	sls_sales != sls_quantity * sls_price OR
	sls_sales IS NULL OR
	sls_quantity IS NULL OR
	sls_price IS NULL OR
	sls_sales <= 0 OR
	sls_quantity <= 0 OR
	sls_price <= 0
ORDER BY
	sls_sales,
	sls_quantity,
	sls_price



/*

DATA CLEANING & INSPECTIONS AGAIN AFTER INSERTING INTO SILVER LAYER

*/


SELECT *
FROM silver.crm_sales_details
WHERE 
	sls_order_dt > sls_ship_dt OR
	sls_order_dt > sls_due_dt;


/* 
Business Rules

	>> Sales = Quantity * Price
	>> Negatives, zeroes, nulls are not allowed!
*/

-- Check Data Consistency: Between Sales, Quantity and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero or negative.

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE
	sls_sales != sls_quantity * sls_price OR
	sls_sales IS NULL OR
	sls_quantity IS NULL OR
	sls_price IS NULL OR
	sls_sales <= 0 OR
	sls_quantity <= 0 OR
	sls_price <= 0
ORDER BY
	sls_sales,
	sls_quantity,
	sls_price


SELECT *
FROM silver.crm_sales_details
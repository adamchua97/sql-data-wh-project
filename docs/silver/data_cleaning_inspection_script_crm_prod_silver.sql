/*

DATA CLEANING AND INSPECTION QUERIES
	- Perform on Bronze layer BEFORE transformations
	- Perform again on Silver layer AFTER to ensure data cleanliness

*/

-- Check for NULLs or duplicates in Primary Key
-- Expectation: No Results

SELECT
	prd_id,
	COUNT(*) AS duplicate_count
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING 
	COUNT(*) > 1 OR
	prd_id IS NULL;



-- Check for unwanted spaces
-- Expectation: No results
-- Use trim function

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


SELECT prd_line
FROM bronze.crm_prd_info
WHERE prd_line != TRIM(prd_line);



-- Check for NULLs or negative numbers
-- Expectation: No results

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE
	prd_cost < 0  OR
	prd_cost IS NULL;


-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;


-- Check for invalid date orders
-- end date must be earlier than the start date
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;




/*

DATA INSPECTION AFTER INSERTING INTO SILVER LAYER PROD TABLE

	- Perform the same checks as above but with the silver prod table

*/

-- Check for NULLs or duplicates in Primary Key
-- Expectation: No Results

SELECT
	prd_id,
	COUNT(*) AS duplicate_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING 
	COUNT(*) > 1 OR
	prd_id IS NULL;



-- Check for unwanted spaces
-- Expectation: No results
-- Use trim function

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


SELECT prd_line
FROM silver.crm_prd_info
WHERE prd_line != TRIM(prd_line);



-- Check for NULLs or negative numbers
-- Expectation: No results

SELECT prd_cost
FROM silver.crm_prd_info
WHERE
	prd_cost < 0  OR
	prd_cost IS NULL;


-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;


-- Check for invalid date orders
-- end date must be earlier than the start date
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


SELECT *
FROM silver.crm_prd_info;
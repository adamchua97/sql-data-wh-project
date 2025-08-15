/*

DATA CLEANING & INSPECTION QUERIES

PERFORM FOR BOTH BRONZE LAYER AND SILVER LAYER AFTER LOADING TO DOUBLE CHECK

*/


-- Check for NULLS or Duplicates in Primary Key
-- Expectation: No Results
-- For selecting the correct single record, choose the most recent created date
SELECT
	cst_id,
	COUNT(*) AS 'Duplicate Count'
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING 
	COUNT(*) > 1 OR
	cst_id IS NULL;


-- Check for unwanted spaces
-- Expectation: No Results
-- Use trim function

SELECT
	cst_key
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key);

SELECT
	cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
	cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT
	cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT
	cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);


-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM
	bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM
	bronze.crm_cust_info;







-- AFTER LOADING DATA INTO SILVER LAYER

-- Perform same checks
-- Check for NULLS or Duplicates in Primary Key
-- Expectation: No Results
-- For selecting the correct single record, choose the most recent created date
SELECT
	cst_id,
	COUNT(*) AS 'Duplicate Count'
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING 
	COUNT(*) > 1 OR
	cst_id IS NULL;


-- Check for unwanted spaces
-- Expectation: No Results
-- Use trim function

SELECT
	cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT
	cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT
	cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);


-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;


SELECT *
FROM silver.crm_cust_info;
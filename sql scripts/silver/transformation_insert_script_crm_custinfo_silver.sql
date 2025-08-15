/*

TRANSFORMATION & INSERT INTO SILVER LAYER CUSTOMER INFO TABLE

Transformation Query:
	- Use Subquery to query from to get all the columns, and use window function to enumerate rows by most recent created date
	- row numbers greater than 1 mean they are duplicates (older records) and filter out NULLs
	- Outer SELECT query for has all data cleaning & transformations
		- Normalize marital status and gender values to readable formats
	- then filter to row numbers that are 1 for all the most recent records per customer


	** Truncating before inserting data to make sure table is empty **

*/



PRINT '>> Truncating Table: silver.crm_cust_info'
TRUNCATE TABLE silver.crm_cust_info
PRINT '>> Inserting Data Into: silver.crm_cust_info'
INSERT INTO silver.crm_cust_info (
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
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' then 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' then 'Married'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE
		WHEN UPPER(TRIM(cst_gndr)) = 'F' then 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' then 'Male'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
FROM
	(SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
	) ranked_date_T
WHERE flag_last = 1;

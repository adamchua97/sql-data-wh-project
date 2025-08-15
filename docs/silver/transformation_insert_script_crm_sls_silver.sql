/*

TRANSFORMATIONS & INSERTION QUERIES


** Truncating before inserting data to make sure table is empty **

*/


PRINT '>> Truncating Table: silver.crm_sales_details'
TRUNCATE TABLE silver.crm_sales_details
PRINT '>> Inserting Data Into: silver.crm_sales_details'
INSERT INTO silver.crm_sales_details (
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
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) !=8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)		-- Cast from INT to VARCHAR first, then cast to DATE type
	END AS sls_order_dt,
	CASE 
		WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) !=8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)		-- Cast from INT to VARCHAR first, then cast to DATE type
	END AS sls_ship_dt,
	CASE 
		WHEN sls_due_dt = 0 OR LEN(sls_due_dt) !=8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)		-- Cast from INT to VARCHAR first, then cast to DATE type
	END AS sls_due_dt,
	CASE 
		WHEN sls_sales IS NULL OR sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales							-- Recalculate sales if original value if is missing or invalid
	END AS sls_sales,
	sls_quantity,
	CASE 
		WHEN sls_price IS NULL OR sls_price <= 0
			THEN sls_sales / NULLIF(sls_quantity, 0) -- Turn to NULL if 0, so it doesn't give a division error
		ELSE sls_price								 -- Derive price if original value is invalid
	END AS sls_price
FROM bronze.crm_sales_details;


/*

BEFORE INSERT, UPDATE THE SILVER LAYER TABLE DDL SCRIPT BECAUSE OF CHANGES IN COLUMNS FROM TRANSFORMATIONS
	- change dates from INT to DATE type

NOTE: Commenting out script after execution
*/


/*
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
*/
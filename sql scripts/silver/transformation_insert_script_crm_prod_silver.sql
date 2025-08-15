/*

TRANSFORMATION & INSERTION SCRIPTS


Fixing invalid date orders:
	- Make sure the end dates aren't earlier than the start dates
	- Changes in product costs are what changes the dates
	- Fix end dates so that it is 1 day before the start date of the next record of the same product (characterized by the key)
	- Use LEAD()


	** Truncating before inserting data to make sure table is empty **
*/




PRINT '>> Truncating Table: silver.crm_prd_info'
TRUNCATE TABLE silver.crm_prd_info
PRINT '>> Inserting Data Into: silver.crm_prd_info'
INSERT INTO silver.crm_prd_info (
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
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- extracting first 5 chars and replacing '-' with '_' to match cat_id in erp table for relationship
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- extracting the remaining chars starting at 7 to match erp sales prod table key for relationship
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost, -- replace nulls with 0's
	CASE UPPER(TRIM(prd_line)) -- simple trick if function is applied to all cases
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;



/*

BEFORE INSERT, UPDATE THE SILVER LAYER TABLE DDL SCRIPT BECAUSE OF CHANGES IN COLUMNS FROM TRANSFORMATIONS
	- add cat_id before prd_key
	- change to DATE types

NOTE: Commenting out script after execution
*/

/*
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
*/
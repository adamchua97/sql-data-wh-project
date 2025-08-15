/*

TRANSFORMATIONS & INSERTION QUERIES


** Truncating before inserting data to make sure table is empty **

*/





PRINT '>> Truncating Table: silver.erp_cust_az12'
TRUNCATE TABLE silver.erp_cust_az12
PRINT '>> Inserting Data Into: silver.erp_cust_az12'
INSERT INTO silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)
SELECT
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- extracting 'NAS' out to match with customer id in silver crm customer info table for relation
		ELSE cid												-- Not all of them start with 'NAS' and already are in the same format
	END AS cid,
	CASE
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END AS gen
FROM [bronze].[erp_cust_az12]

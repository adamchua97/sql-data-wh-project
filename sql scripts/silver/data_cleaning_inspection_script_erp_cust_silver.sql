/*

DATA CLEANING AND INSPECTION QUERIES


PERFORM ON BRONZE LAYER BEFORE INSERTION AND ON SILVER LAYER AFTER TRANSFORMATION TO MAKE SURE DATA CLEANLINESS

*/



-- Identify out of range dates

SELECT DISTINCT
	cid,
	bdate,
	gen
FROM [bronze].[erp_cust_az12]
WHERE 
	bdate < '1924-01-01' OR   -- check for 100 years because it seems unlikely that customers may be that old
	bdate > GETDATE()		  -- check for birth dates that are beyond current date


-- Data Standardization and Consistency

SELECT DISTINCT
	gen
FROM bronze.erp_cust_az12




/*

PERFORM SAME CHECKS ON SILVER LAYER TABLE AFTER INSERTION TO ENSURE DATA QUALITY AND CLEANLINESS

*/



-- Identify out of range dates

SELECT DISTINCT
	cid,
	bdate,
	gen
FROM [silver].[erp_cust_az12]
WHERE 
	bdate < '1924-01-01' OR   -- check for 100 years because it seems unlikely that customers may be that old
	bdate > GETDATE()		  -- check for birth dates that are beyond current date


-- Data Standardization and Consistency

SELECT DISTINCT
	gen
FROM silver.erp_cust_az12
/*

DATA CLEANING & INSPECTION QUERIES

PERFORM ON BRONZE LAYER BEFORE INSERT AND AFTER ON SILVER LAYER TO ENSURE DATA QUALITY AND CLEANLINESS

*/



-- Data Standardization & Consistency

SELECT DISTINCT
	cntry
FROM bronze.erp_loc_a101
ORDER BY cntry





/*
PERFORM SAME CHECKS AFTER INSERTION ON SILVER LAYER
*/


-- Data Standardization & Consistency

SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101
ORDER BY cntry


SELECT * FROM silver.erp_loc_a101
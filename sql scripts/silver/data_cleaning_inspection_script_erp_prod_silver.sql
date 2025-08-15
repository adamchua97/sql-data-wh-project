/*

DATA CLEANING & INSPECTION

PERFORM ON BRONZE LAYER BEFORE INSERT AND AFTER ON SILVER LAYER TO ENSURE DATA QUALITY AND CLEANLINESS

*/



SELECT *
FROM bronze.erp_px_cat_g1v2




-- Check for unwanted spaces

SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);


SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);


SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);


-- Data Standardization & Consistency

SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2


SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2


SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2


/*
NO NEED TO PERFORM SAME CHECKS ON SILVER LAYER BECAUSE DATA WAS ALREADY IN GOOD SHAPE
*/

SELECT * FROM silver.erp_px_cat_g1v2;
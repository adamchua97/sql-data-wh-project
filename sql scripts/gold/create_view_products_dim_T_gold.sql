/*
	
	CREATING A VIEW FOR GOLD LAYER PRODUCT TABLE:

	- Main query to join all product related tables from CRM and ERP sources
	- Follow proper friendly naming conventions for columns
	- Commenting out after execution
	- See queries below for further inspection to see if proper integrations are needed to get all data matching to master source (CRM)

	This is a DIMENSTION Table since:
		- Data are descriptive
		- No numerical measures, which are needed in a FACT table

*/


-- CREATE VIEW gold.dim_products AS		>> ALREADY EXECUTED
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Primary Key (Surrogate)
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category, 
	pc.subcat AS subcategory,
	pc.maintenance AS maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL; -- Filter out all historical data (project requirements does not require them)



----------------------------------------------------------------------------------

-- Wrapping in CTE to check for duplicates

WITH prod_tables AS (
	SELECT
		pn.prd_id,
		pn.cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		pc.cat,
		pc.subcat,
		pc.maintenance
	FROM silver.crm_prd_info pn
	LEFT JOIN silver.erp_px_cat_g1v2 pc
		ON pn.cat_id = pc.id
	WHERE prd_end_dt IS NULL -- Filter out all historical data (project requirements does not require them)
)
SELECT
	prd_key,
	COUNT(*) AS duplicate_count
FROM prod_tables
GROUP BY prd_key
HAVING COUNT(*) > 1;



-- Check products that have NULLs for end dates, which means they are current and open
-- Will be the ones to record in DWH
-- Will filter out all historical data in View

SELECT
	pn.prd_id,
	pn.cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info pn
WHERE prd_end_dt IS NULL;
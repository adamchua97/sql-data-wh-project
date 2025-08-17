/*
	
	CREATING A VIEW FOR GOLD LAYER CUSTOMERS TABLE:

	- Main query to join all customer related tables
	- Follow proper friendly naming conventions for columns
	- Commenting out after execution
	- See queries below for further inspection to see if proper integrations are needed to get all data matching to master source (CRM)

	This is a DIMENSTION Table since:
		- Data are descriptive
		- No numerical measures, which are needed in a FACT table

*/

--CREATE VIEW gold.dim_customers AS		>> ALREADY EXECUTED
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Primary Key (Surrogate)
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid;




----------------------------------------------------------------------------

-- Wrapping in CTE to check for duplicates

WITH cust_tables AS (
	SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
		ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
		ON ci.cst_key = la.cid
)
SELECT
	cst_id,
	COUNT(*) AS duplicate_count
FROM cust_tables
GROUP BY cst_id
HAVING COUNT(*) > 1;



-- Data integration because of two possible sources for gender
-- There's inconsistent/unmatching/unavailable data from different customer tables
-- Which is the main source of accurate information? CRM or ERP

SELECT DISTINCT
	ci.cst_gndr,
	ca.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
ORDER BY 1,2;


-- Follow the data based on CRM since it is the master source for customer information
-- Integrate the ERP gender data to match the CRM gender data
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- if not null from crm gender data then leave as it is
		ELSE COALESCE(ca.gen, 'n/a')				-- if null from erp gender data then put 'n/a' to match crm data
	END AS new_gndr
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
ORDER BY 1,2;
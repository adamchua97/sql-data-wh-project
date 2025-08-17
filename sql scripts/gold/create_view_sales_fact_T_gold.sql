/*


	CREATING VIEW FOR SALES FACT TABLE

	- Main query to join all the dimension tables keys to develop this fact table
	- Follow proper friendly naming conventions for columns
	- Get the primary surrogate keys from the dimension tables
	- No need for the sales product and sales customer id
		- The primary keys from the dimension tables act as their reference (foreign keys) for the fact table
		- They will be the look up references for descriptive data for the records in the fact table


*/

-- CREATE VIEW gold.fact_sales AS		>> ALREADY EXECUTED
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key, -- get the primary surrogate key from the product dimension table to be foreign key
	cu.customer_key, -- get the primary surrogate key from the custommer dimension table to be foreign key
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number -- sales product key relates to the product number in product table
LEFT JOIN gold.dim_customers cu
	ON sd.sls_cust_id = cu.customer_id;  -- sales customer id relates to the customer id in customer table

-------------------------------------------------------------------------------------------------------


-- Foreign Key Integrity (Dimensions)

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;


SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
WHERE p.product_key IS NULL;
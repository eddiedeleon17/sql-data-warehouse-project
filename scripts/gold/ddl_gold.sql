/*
===============================================================================
Script DDL: Crear Views de la Gold Layer
===============================================================================
Propósito del script:
    Este script crea las views de la Gold Layer del data warehouse. La Gold
    Layer representa las tablas de dimensiones y de hechos siguiendo un
    esquema estrella (Star Schema).

    Cada view combina y transforma los datos de la Silver Layer para producir
    un dataset limpio, enriquecido y listo para el negocio.

Uso:
    - Estas views se pueden consultar directamente para análisis y reportería.
===============================================================================
*/

--=============================================================================
--CREATE DIMENSION: gold.dim_customers
--=============================================================================

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr --CRM is Master for Gender
	ELSE COALESCE(ca.gen, 'N/A')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date

FROM silver.crm_cust_info AS ci

LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid

--=============================================================================
--CREATE DIMENSION: gold.dim_products
--=============================================================================

CREATE VIEW gold.dim_products AS
SELECT
ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
pn.prd_id AS product_id,
pn.prd_key AS product_number,
pn.prd_nm AS product_name,
pn.cat_id AS category_id,
pc.cat AS category,
pc.subcat AS subcategory,
pc.maintenance,
pn.prd_cost AS cost,
pn.prd_line AS product_line,
pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn

LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id 
WHERE pn.prd_end_dt IS NULL --filter out historical data

--=============================================================================
--CREATE FACT: gold.fact_sales
--=============================================================================

CREATE VIEW gold.fact_sales AS 
SELECT
sd.sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS ship_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS Sales_Amount,
sd.sls_quantity AS Sales_Quantity,
sd.sls_price AS Price
FROM silver.crm_sales_details AS sd

LEFT JOIN gold.dim_products AS pr
ON sd.sls_prd_key = pr.product_number 

LEFT JOIN gold.dim_customers AS cu
ON sd.sls_cust_id = cu.customer_id

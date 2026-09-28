/*
===============================================================================
Script de Calidad: Validación de la Silver Layer
===============================================================================
Propósito del script:
    Este script ejecuta una serie de chequeos de calidad para verificar la
    consistencia, precisión y estandarización de los datos del esquema 'silver'.
    Incluye validaciones de:
    - Nulos o duplicados en las llaves primarias.
    - Espacios no deseados en campos de texto.
    - Estandarización y consistencia de los campos normalizados.
    - Rangos de fechas válidos y orden cronológico correcto.
    - Consistencia entre los campos relacionados (sales = quantity * price).

Uso:
    - Ejecutá estos chequeos después de cargar la Silver Layer.
    - Investigá y corregí cualquier discrepancia encontrada en los resultados.
===============================================================================
*/

--========================================================
--SILVER: TABLE 1 silver.crm_cust_info CHECK QUALITY DATA
--========================================================
--Check for Nulls or Duplicates in Primary Key
--Expectation: No result

SELECT
cst_id,
COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL 

--Check for unwanted spaces
--Expectation: No Results 
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key)

--Data Standarization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT* FROM silver.crm_cust_info

--========================================================
--SILVER: TABLE 2 silver.crm_prd_info CHECK QUALITY DATA
--========================================================
--Check for Nulls or Duplicates in Primary Key
--Expectation: No result
SELECT
prd_id,
COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL 

--Check for unwanted spaces
--Expectation: No Results 

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for NULLS or Negative Numbers
--Expectation: No Results 
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

--Data Standarization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

--Check Invalid Date Orders
SELECT*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT* FROM silver.crm_prd_info

--===========================================================
--SILVER: TABLE 3 silver.crm_sales_details CHECK QUALITY DATA
--===========================================================
--Check for invalid dates
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101 
OR sls_order_dt < 219000101

--Cheack for Invalid Date Order
SELECT*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--Check Data consistency: Sales, Quantity, Price
--Expected Result: values not be Null, Zero or negative

SELECT DISTINCT 
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0 
ORDER BY sls_sales, sls_quantity, sls_price

SELECT* FROM silver.crm_sales_details


--===========================================================
--SILVER: TABLE 4 silver.erp_cust_az12 CHECK QUALITY DATA
--===========================================================

--Identify Out Of Range Dates
SELECT DISTINCT 
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

--Data Standarization & Consistency
SELECT DISTINCT gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'N/A'
END AS gen

FROM silver.erp_cust_az12

SELECT* FROM silver.erp_cust_az12

--========================================================
--SILVER: TABLE 5 silver.erp_loc_a101 CHECK QUALITY DATA
--========================================================

--Data Standarization & Consistency

SELECT DISTINCT
cntry

FROM silver.erp_loc_a101
ORDER BY cntry

SELECT* FROM  silver.erp_loc_a101

--========================================================
--SILVER: TABLE 6 silver.erp_px_cat_g1v2 CHECK QUALITY DATA
--========================================================

SELECT* FROM silver.erp_px_cat_g1v2

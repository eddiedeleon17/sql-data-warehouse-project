/*
===============================================================================
Script de Calidad: Exploración de la Bronze Layer
===============================================================================
Propósito del script:
    Este script ejecuta una serie de chequeos de calidad sobre el esquema
    'bronze' para identificar los problemas de los datos crudos antes de
    escribir las transformaciones de la Silver Layer. Incluye validaciones de:
    - Nulos o duplicados en las llaves primarias.
    - Espacios no deseados en campos de texto.
    - Valores nulos o negativos en campos numéricos.
    - Rangos de fechas válidos y orden cronológico correcto.
    - Consistencia entre campos relacionados (sales = quantity * price).
    - Valores distintos en los campos que requieren estandarización.

    Algunos chequeos incluyen la columna original junto a la versión corregida,
    para validar la lógica de transformación antes de aplicarla en silver.

Uso:
    - Ejecutá estos chequeos antes de construir la Silver Layer.
    - Cada hallazgo define una regla de limpieza a implementar.
===============================================================================
*/


--========================================================
--BRONZE: TABLE 1 bronze.crm_cust_info CHECK QUALITY DATA
--========================================================

--Check for Nulls or Duplicates in Primary Key
--Expectation: No result

SELECT
cst_id,
COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL 

--Check for unwanted spaces
--Expectation: No Results 
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

SELECT cst_key
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key)

--Data Standarization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info

SELECT* FROM silver.crm_cust_info

--========================================================
--BRONZE: TABLE 2 bronze.crm_prd_info CHECK QUALITY DATA
--========================================================
--Check for Nulls or Duplicates in Primary Key
--Expectation: No result
SELECT
prd_id,
COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL 

--Check for unwanted spaces
--Expectation: No Results 

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for NULLS or Negative Numbers
--Expectation: No Results 
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

--Data Standarization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

--Check Invalid Date Orders
SELECT*
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--========================================================
--BRONZE: TABLE 3 bronze.crm_sales_details CHECK QUALITY DATA
--========================================================
--Check for invalid dates
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101 
OR sls_order_dt < 219000101

--Cheack for Invalid Date Order
SELECT*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--Check Data consistency: Sales, Quantity, Price
--Expected Result: values not be Null, Zero or negative

SELECT DISTINCT 
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price, 
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales 
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0 
		THEN sls_sales / NULLIF(sls_quantity, 0) 
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0 
ORDER BY sls_sales, sls_quantity, sls_price

--========================================================
--BRONZE: TABLE 4 bronze.erp_cust_az12 CHECK QUALITY DATA
--========================================================

--Identify Out Of Range Dates
SELECT DISTINCT 
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

--Data Standarization & Consistency
SELECT DISTINCT gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'N/A'
END AS gen

FROM bronze.erp_cust_az12

--========================================================
--BRONZE: TABLE 5 bronze.erp_loc_a101 CHECK QUALITY DATA
--========================================================

--Data Standarization & Consistency

SELECT DISTINCT
cntry AS old_cntry,
CASE WHEN TRIM(cntry)='DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
	 WHEN TRIM(cntry)='' OR cntry IS NULL THEN 'N/A'
	 ELSE TRIM(cntry)
END AS cntry

FROM bronze.erp_loc_a101
ORDER BY cntry

--========================================================
--BRONZE: TABLE 6 bronze.erp_px_cat_g1v2 CHECK QUALITY DATA
--========================================================

--Check unwanted spaces
SELECT* FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM (cat) OR subcat != TRIM (subcat) OR maintenance != TRIM(maintenance)

--Data Standarization & Consistency
SELECT DISTINCT 
cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT 
subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT 
maintenance
FROM bronze.erp_px_cat_g1v2;

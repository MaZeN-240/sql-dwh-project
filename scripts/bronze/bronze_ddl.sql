/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist, calculating its loading duration.
    Run this script to re-define the DDL structure of 'bronze' Tables.
===============================================================================
*/
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time         TIMESTAMPTZ;
    v_end_time           TIMESTAMPTZ;
    v_batch_start_time   TIMESTAMPTZ;
    v_batch_end_time     TIMESTAMPTZ;
    row_cnt              INT;
BEGIN
    -- Record total batch execution start time
    v_batch_start_time := CLOCK_TIMESTAMP();

    RAISE NOTICE '==================================================';
    RAISE NOTICE 'Starting Bronze Layer Load (With Exception Handling)';
    RAISE NOTICE '==================================================';

    -- =========================================================
    -- 1. Importing crm_cust_info
    -- =========================================================
    BEGIN
        v_start_time := CLOCK_TIMESTAMP();
        TRUNCATE TABLE bronze.crm_cust_info CASCADE;
        
        COPY bronze.crm_cust_info FROM 'C:\cust_info.csv' DELIMITER ',' CSV HEADER;
        
        GET DIAGNOSTICS row_cnt = ROW_COUNT;
        v_end_time := CLOCK_TIMESTAMP();
        RAISE NOTICE '>> SUCCESS: crm_cust_info | Rows: % | Duration: % seconds', 
                     row_cnt, EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '>> FAILED: crm_cust_info | Error: %', SQLERRM;
    END;

    -- =========================================================
    -- 2. Importing crm_prd_info
    -- =========================================================
    BEGIN
        v_start_time := CLOCK_TIMESTAMP();
        TRUNCATE TABLE bronze.crm_prd_info CASCADE;
        
        COPY bronze.crm_prd_info FROM 'C:\prd_info.csv' DELIMITER ',' CSV HEADER;
        
        GET DIAGNOSTICS row_cnt = ROW_COUNT;
        v_end_time := CLOCK_TIMESTAMP();
        RAISE NOTICE '>> SUCCESS: crm_prd_info | Rows: % | Duration: % seconds', 
                     row_cnt, EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '>> FAILED: crm_prd_info | Error: %', SQLERRM;
    END;

    -- =========================================================
    -- 3. Importing crm_sales_details
    -- =========================================================
    BEGIN
        v_start_time := CLOCK_TIMESTAMP();
        TRUNCATE TABLE bronze.crm_sales_details CASCADE;
        
        COPY bronze.crm_sales_details FROM 'C:\sales_details.csv' DELIMITER ',' CSV HEADER;
        
        GET DIAGNOSTICS row_cnt = ROW_COUNT;
        v_end_time := CLOCK_TIMESTAMP();
        RAISE NOTICE '>> SUCCESS: crm_sales_details | Rows: % | Duration: % seconds', 
                     row_cnt, EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '>> FAILED: crm_sales_details | Error: %', SQLERRM;
    END;

    -- =========================================================
    -- 4. Importing erp_cust_az12
    -- =========================================================
    BEGIN
        v_start_time := CLOCK_TIMESTAMP();
        TRUNCATE TABLE bronze.erp_cust_az12 CASCADE;
        
        COPY bronze.erp_cust_az12 FROM 'C:\CUST_AZ12.csv' DELIMITER ',' CSV HEADER;
        
        GET DIAGNOSTICS row_cnt = ROW_COUNT;
        v_end_time := CLOCK_TIMESTAMP();
        RAISE NOTICE '>> SUCCESS: erp_cust_az12 | Rows: % | Duration: % seconds', 
                     row_cnt, EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '>> FAILED: erp_cust_az12 | Error: %', SQLERRM;
    END;

    -- =========================================================
    -- 5. Importing erp_loc_a101
    -- =========================================================
    BEGIN
        v_start_time := CLOCK_TIMESTAMP();
        TRUNCATE TABLE bronze.erp_loc_a101 CASCADE;
        
        COPY bronze.erp_loc_a101 FROM 'C:\LOC_A101.csv' DELIMITER ',' CSV HEADER;
        
        GET DIAGNOSTICS row_cnt = ROW_COUNT;
        v_end_time := CLOCK_TIMESTAMP();
        RAISE NOTICE '>> SUCCESS: erp_loc_a101 | Rows: % | Duration: % seconds', 
                     row_cnt, EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '>> FAILED: erp_loc_a101 | Error: %', SQLERRM;
    END;

    -- =========================================================
    -- 6. Importing erp_px_cat_g1v2
    -- =========================================================
    BEGIN
        v_start_time := CLOCK_TIMESTAMP();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2 CASCADE;
        
        COPY bronze.erp_px_cat_g1v2 FROM 'C:\PX_CAT_G1V2.csv' DELIMITER ',' CSV HEADER;
        
        GET DIAGNOSTICS row_cnt = ROW_COUNT;
        v_end_time := CLOCK_TIMESTAMP();
        RAISE NOTICE '>> SUCCESS: erp_px_cat_g1v2 | Rows: % | Duration: % seconds', 
                     row_cnt, EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE '>> FAILED: erp_px_cat_g1v2 | Error: %', SQLERRM;
    END;

    -- Record total batch execution end time
    v_batch_end_time := CLOCK_TIMESTAMP();
    RAISE NOTICE '==================================================';
    RAISE NOTICE 'Total Batch Duration: % seconds', EXTRACT(EPOCH FROM (v_batch_end_time - v_batch_start_time));
    RAISE NOTICE '==================================================';

END;
$$;

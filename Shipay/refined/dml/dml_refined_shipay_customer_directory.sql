
-- ** customer_directory    **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.refined_shipay.customer_directory`  AS bronze
USING (
  SELECT
    * 
  FROM (
SELECT
    * ,
   
  FROM (
SELECT 
  'GCP' as origem,
  pv.id AS vendor_id,
  pv.name AS vendor_name,
  pv.cnpj AS vendor_cnpj,
  pv.email AS vendor_email,
  pv.uuid AS vendor_uuid,
  pv.active AS vendor_status,
  pv.created_at AS vendor_created,
  pp.id AS product_id,
  pp.name AS product_name,
  pp.email AS product_email,
  pp.active AS product_active,
  pp.created_at AS product_created,
  rc.name AS retail_name, -- included retail chain name from the join
  rc.degree as retail_degree,
  cus.degree as customer_degree,
  cus.id AS customer_id,
  cus.name AS customer_name,
  cus.email AS customer_email,
  cus.created_at AS customer_created,
  cus.uuid AS customer_uuid,
  cus.external_crm_id AS customer_crm_id,
  st.id AS stores_id,
  st.name AS stores_name,
  st.created_at AS stores_created,
  st.city_name AS stores_city,
  st.state_name AS stores_state,
  st.person_type AS stores_type,
  st.cnpj_cpf AS stores_cnpj_cpf,
  st.active AS store_active,
  sp.id AS store_pos_id,
  sp.name AS s_pos_name,
  sp.created_at AS s_pos_created,
  sp.active AS s_pos_active,
  sp.category AS s_pos_category,
  CURRENT_TIMESTAMP() AS last_refresh, 
  pv.created_at_date,
  ROW_NUMBER() OVER(PARTITION BY sp.id ORDER BY sp.created_at DESC) AS rnk
FROM `production-347022.trusted_shipay.pos_vendors` pv
LEFT JOIN `production-347022.trusted_shipay.pos_products` pp ON pv.id  = pp.pos_vendor_id
LEFT JOIN `production-347022.trusted_shipay.customers` cus ON cus.degree  LIKE CONCAT(pp.degree, '.%') 
LEFT JOIN `production-347022.trusted_shipay.stores` st ON cus.id  = st.customer_id
LEFT JOIN `production-347022.trusted_shipay.store_pos` sp ON st.id  = sp.store_id
LEFT JOIN production-347022.trusted_shipay.retail_chains rc ON cast(cus.degree as string) LIKE CONCAT(rc.degree, '.%')
--where  pv.created_at_date = current_date()
  --  and SAFE_CAST(pv.updated_at AS DATETIME) between  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 100 HOUR) 
   -- AND  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 1 HOUR)
     )
WHERE
    rnk = 1
    	union all
SELECT
    * ,
   
  FROM (
SELECT 
  'AWS' as origem,
  pv.id AS vendor_id,
  pv.name AS vendor_name,
  pv.cnpj AS vendor_cnpj,
  pv.email AS vendor_email,
  pv.uuid AS vendor_uuid,
  pv.active AS vendor_status,
  pv.created_at AS vendor_created,
  pp.id AS product_id,
  pp.name AS product_name,
  pp.email AS product_email,
  pp.active AS product_active,
  pp.created_at AS product_created,
  rc.name AS retail_name, -- included retail chain name from the join
  rc.degree as retail_degree,
  cus.degree as customer_degree,
  cus.id AS customer_id,
  cus.name AS customer_name,
  cus.email AS customer_email,
  cus.created_at AS customer_created,
  cus.uuid AS customer_uuid,
  cus.external_crm_id AS customer_crm_id,
  st.id AS stores_id,
  st.name AS stores_name,
  st.created_at AS stores_created,
  st.city_name AS stores_city,
  st.state_name AS stores_state,
  st.person_type AS stores_type,
  st.cnpj_cpf AS stores_cnpj_cpf,
  st.active AS store_active,
  sp.id AS store_pos_id,
  sp.name AS s_pos_name,
  sp.created_at AS s_pos_created,
  sp.active AS s_pos_active,
  sp.category AS s_pos_category,
  CURRENT_TIMESTAMP() AS last_refresh, 
  pv.created_at_date,
  ROW_NUMBER() OVER(PARTITION BY sp.id ORDER BY sp.created_at DESC) AS rnk
FROM `production-347022.trusted_shipay_aws.pos_vendors` pv
LEFT JOIN `production-347022.trusted_shipay_aws.pos_products` pp ON pv.id  = pp.pos_vendor_id
LEFT JOIN `production-347022.trusted_shipay_aws.customers` cus ON cus.degree LIKE CONCAT(pp.degree, '.%') 
LEFT JOIN `production-347022.trusted_shipay_aws.stores` st ON cus.id  = st.customer_id
LEFT JOIN `production-347022.trusted_shipay_aws.store_pos` sp ON st.id  = sp.store_id
LEFT JOIN production-347022.trusted_shipay_aws.retail_chains rc ON cast(cus.degree as string) LIKE CONCAT(rc.degree, '.%')
where  pv.created_at_date = current_date()
    and SAFE_CAST(pv.updated_at AS DATETIME) between  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR) 
    AND  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 1 HOUR)
     )
WHERE
    rnk = 1
)) AS raw

ON  bronze.vendor_id 					    =	raw.vendor_id 

WHEN MATCHED THEN UPDATE SET
bronze.origem = raw.origem						,
bronze.vendor_id = raw.vendor_id                ,
bronze.vendor_name = raw.vendor_name            ,
bronze.vendor_cnpj = raw.vendor_cnpj            ,
bronze.vendor_email = raw.vendor_email          ,
bronze.vendor_uuid = raw.vendor_uuid            ,
bronze.vendor_status = raw.vendor_status        ,
bronze.vendor_created = raw.vendor_created      ,
bronze.product_id = raw.product_id              ,
bronze.product_name = raw.product_name          ,
bronze.product_email = raw.product_email        ,
bronze.product_active = raw.product_active      ,
bronze.product_created = raw.product_created    ,
bronze.retail_name  = raw.retail_name           ,
bronze.retail_degree = raw.retail_degree        ,
bronze.customer_degree = raw.customer_degree    ,
bronze.customer_id = raw.customer_id            ,
bronze.customer_name = raw.customer_name        ,
bronze.customer_email = raw.customer_email      ,
bronze.customer_created = raw.customer_created  ,
bronze.customer_uuid = raw.customer_uuid        ,
bronze.customer_crm_id = raw.customer_crm_id    ,
bronze.stores_id = raw.stores_id                ,
bronze.stores_name = raw.stores_name            ,
bronze.stores_created = raw.stores_created      ,
bronze.stores_city = raw.stores_city            ,
bronze.stores_state = raw.stores_state          ,
bronze.stores_type = raw.stores_type            ,
bronze.stores_cnpj_cpf = raw.stores_cnpj_cpf    ,
bronze.store_active = raw.store_active          ,
bronze.store_pos_id = raw.store_pos_id          ,
bronze.s_pos_name = raw.s_pos_name              ,
bronze.s_pos_created = raw.s_pos_created        ,
bronze.s_pos_active = raw.s_pos_active          ,
bronze.s_pos_category = raw.s_pos_category      ,
bronze.last_refresh  = raw.last_refresh         ,
bronze.created_at_date = raw.created_at_date    



WHEN NOT MATCHED THEN INSERT (
origem,
  vendor_id,
  vendor_name,
  vendor_cnpj,
   vendor_email,
  vendor_uuid,
  vendor_status,
  vendor_created,
  product_id,
  product_name,
  product_email,
   product_active,
  product_created,
  retail_name, 
   retail_degree,
  customer_degree,
  customer_id,
  customer_name,
   customer_email,
  customer_created,
  customer_uuid,
  customer_crm_id,
  stores_id,
  stores_name,
  stores_created,
   stores_city,
   stores_state,
   stores_type,
  stores_cnpj_cpf,
  store_active,
   store_pos_id,
  s_pos_name,
  s_pos_created,
  s_pos_active,
  s_pos_category,
  last_refresh, 
  created_at_date

)
VALUES (

raw.origem,
raw.vendor_id,
raw.vendor_name,
raw.vendor_cnpj,
raw.vendor_email,
raw.vendor_uuid,
raw.vendor_status,
raw.vendor_created,
raw.product_id,
raw.product_name,
raw.product_email,
raw.product_active,
raw.product_created,
raw.retail_name, 
raw.retail_degree,
raw.customer_degree,
raw.customer_id,
raw.customer_name,
raw.customer_email,
raw.customer_created,
raw.customer_uuid,
raw.customer_crm_id,
raw.stores_id,
raw.stores_name,
raw.stores_created,
raw.stores_city,
raw.stores_state,
raw.stores_type,
raw.stores_cnpj_cpf,
raw.store_active,
raw.store_pos_id,
raw.s_pos_name,
raw.s_pos_created,
raw.s_pos_active,
raw.s_pos_category,
raw.last_refresh, 
raw.created_at_date
);
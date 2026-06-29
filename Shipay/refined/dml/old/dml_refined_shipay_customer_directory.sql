insert into `production-347022.refined_shipay.customer_directory` 


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
-- LEFT JOIN (
--     SELECT distinct rc.name, count(*)
--     FROM `production-347022.trusted_shipay_aws.retail_chains` rc
--     GROUP BY rc.name 
--     HAVING COUNT(rc.name) = 1
-- ) rc ON TRUE 
LEFT JOIN production-347022.trusted_shipay_aws.retail_chains rc ON cast(cus.degree as string) LIKE CONCAT(rc.degree, '.%')
where  pv.created_at_date = current_date()
    and SAFE_CAST(pv.updated_at AS DATETIME) between  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR) 
    AND  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 1 HOUR)
     )
WHERE
    rnk = 1
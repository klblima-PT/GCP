CREATE TABLE IF NOT EXISTS `production-347022.refined_shipay.customer_directory`
(
  origem STRING,
  vendor_id INT64,
  vendor_name STRING,
  vendor_cnpj STRING,
  vendor_email STRING,
  vendor_uuid STRING,
  vendor_status BOOL,
  vendor_created TIMESTAMP,
  product_id INT64,
  product_name STRING,
  product_email STRING,
  product_active BOOL,
  product_created TIMESTAMP,
  retail_name STRING,
  retail_degree STRING,
  customer_degree STRING,
  customer_id INT64,
  customer_name STRING,
  customer_email STRING,
  customer_created TIMESTAMP,
  customer_uuid STRING,
  customer_crm_id STRING,
  stores_id INT64,
  stores_name STRING,
  stores_created TIMESTAMP,
  stores_city STRING,
  stores_state STRING,
  stores_type STRING,
  stores_cnpj_cpf STRING,
  store_active BOOL,
  store_pos_id INT64,
  s_pos_name STRING,
  s_pos_created TIMESTAMP,
  s_pos_active BOOL,
  s_pos_category STRING,
  last_refresh TIMESTAMP,
  created_at_date DATE,
  rnk INT64


  origem	vendor_id	vendor_name	vendor_cnpj	vendor_email	vendor_uuid	vendor_status	vendor_created	product_id	product_name	product_email	product_active	product_created	
  retail_name	retail_degree	customer_degree	customer_id	customer_name	customer_email	customer_created	customer_uuid	customer_crm_id	stores_id	stores_name	stores_created	
  stores_city	stores_state	stores_type	stores_cnpj_cpf	store_active	store_pos_id	s_pos_name	s_pos_created	s_pos_active	s_pos_category	last_refresh	created_at_date	rnk

)
PARTITION BY created_at_date
CLUSTER BY  store_pos_id, vendor_id, customer_id, customer_name;
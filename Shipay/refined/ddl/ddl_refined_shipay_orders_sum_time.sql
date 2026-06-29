CREATE TABLE IF NOT EXISTS `production-347022.refined_shipay.orders_sum_time`
(
 origem STRING,
  orders_created_date TIMESTAMP,
  orders_payment_date TIMESTAMP,
  expiration_date TIMESTAMP, 
  order_status STRING,
  store_pos_id INT64,
  wallet_name STRING,
  psp_provider STRING,
  wallet_type STRING,
  orders_date_week int64,
  day_of_week int64,
  week_of_month int64,
  order_type STRING,
  wallet_setting_id INT64,
  bolepix_payment_method STRING,
  last_refresh TIMESTAMP,
  created_at_date DATE,
  order_count INT64,
  orders_value FLOAT64
)
PARTITION BY created_at_date
CLUSTER BY orders_created_date, store_pos_id, order_status, psp_provider;
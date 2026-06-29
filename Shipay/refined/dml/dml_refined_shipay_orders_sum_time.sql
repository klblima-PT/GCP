
-- ** orders_sum_time  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.refined_shipay.orders_sum_time`  AS bronze
USING (
  SELECT
    *
  FROM (

select origem, orders_created_date, orders_payment_date, orders_expiration_date,  order_status, store_pos_id, wallet_name, 
psp_provider, wallet_type, orders_date_week,day_of_week, week_of_month, order_type,wallet_setting_id, bolepix_payment_method, CURRENT_TIMESTAMP() AS last_refresh, created_at_date,
 count(order_id) as order_count, sum(orders_value) as orders_value
 from (
SELECT 
  'GCP' as origem,  
  safe_cast(FORMAT_TIMESTAMP('%Y-%m-%d %H:00:00',(DATETIME_SUB(DATETIME(a.created_at), INTERVAL 3 HOUR)))as timestamp)  AS orders_created_date,
  safe_cast(FORMAT_TIMESTAMP('%Y-%m-%d %H:00:00',(DATETIME_SUB(DATETIME(a.expiration_date), INTERVAL 3 HOUR)))as timestamp) AS orders_expiration_date, 
  safe_cast(FORMAT_TIMESTAMP('%Y-%m-%d %H:00:00',(DATETIME_SUB(DATETIME(a.payment_date), INTERVAL 3 HOUR)))as timestamp) AS orders_payment_date, 
  a.STATUS AS order_status,
  a.store_pos_id AS store_pos_id,
  b.wallet_name AS wallet_name,
  COALESCE(c.wallet_name, b.wallet_name) AS psp_provider,
  b.wallet_type AS wallet_type,
  0 AS orders_date_week,
  0 AS day_of_week, -- adjusted extraction
  0 AS week_of_month,
  a.type AS order_type,
  a.wallet_setting_id,
  d.payment_method AS bolepix_payment_method,
  a.created_at_date,
  (a.id) AS order_id,
  (SAFE_CAST(a.total_order AS FLOAT64)) AS orders_value, 
  a.dt_carga_trusted,
  ROW_NUMBER() OVER(PARTITION BY  a.store_pos_id, a.created_at ORDER BY a.dt_carga_trusted DESC) AS rnk
FROM `production-347022.trusted_shipay.orders` a
LEFT JOIN production-347022.trusted_shipay.system_wallets b ON a.wallet_id  = b.id
LEFT JOIN production-347022.trusted_shipay.system_wallets c ON a.order_generated_by_wallet_id  = c.id
LEFT JOIN production-347022.trusted_shipay.bank_slip d ON d.order_id  = a.id
WHERE SAFE_CAST(a.updated_at AS DATETIME) between  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 100 HOUR) 
   AND  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 1 HOUR)
   )
   where rnk = 1
group by origem, orders_created_date, orders_expiration_date, orders_payment_date, order_status, store_pos_id, wallet_name, 
psp_provider, wallet_type, orders_date_week,day_of_week, week_of_month, order_type,wallet_setting_id, bolepix_payment_method,created_at_date

)) AS raw

ON  bronze.store_pos_id 					    =	raw.store_pos_id 
	and bronze.orders_created_date =	raw.orders_created_date
WHEN MATCHED THEN UPDATE SET
 bronze.origem                      = raw.origem
,bronze.orders_created_date         = raw.orders_created_date
,bronze.orders_payment_date         = raw.orders_payment_date
,bronze.expiration_date      = raw.orders_expiration_date
,bronze.order_status                = raw.order_status
,bronze.store_pos_id                = raw.store_pos_id
,bronze.wallet_name                 = raw.wallet_name
,bronze.psp_provider                = raw.psp_provider
,bronze.wallet_type                 = raw.wallet_type
,bronze.orders_date_week            = raw.orders_date_week
,bronze.day_of_week                 = raw.day_of_week
,bronze.week_of_month               = raw.week_of_month
,bronze.order_type                  = raw.order_type
,bronze.wallet_setting_id           = raw.wallet_setting_id
,bronze.bolepix_payment_method      = raw.bolepix_payment_method
,bronze.last_refresh                = raw.last_refresh
,bronze.created_at_date             = raw.created_at_date
,bronze.order_count                 = raw.order_count
,bronze.orders_value				= raw.orders_value



WHEN NOT MATCHED THEN INSERT (
 origem
,orders_created_date
,orders_payment_date
,expiration_date
,order_status
,store_pos_id
,wallet_name
,psp_provider
,wallet_type
,orders_date_week
,day_of_week
,week_of_month
,order_type
,wallet_setting_id
,bolepix_payment_method
,last_refresh
,created_at_date
,order_count
,orders_value

)
VALUES (

 raw.origem
,raw.orders_created_date
,raw.orders_payment_date
,raw.orders_expiration_date
,raw.order_status
,raw.store_pos_id
,raw.wallet_name
,raw.psp_provider
,raw.wallet_type
,raw.orders_date_week
,raw.day_of_week
,raw.week_of_month
,raw.order_type
,raw.wallet_setting_id
,raw.bolepix_payment_method
,raw.last_refresh
,raw.created_at_date
,raw.order_count
,raw.orders_value					
);
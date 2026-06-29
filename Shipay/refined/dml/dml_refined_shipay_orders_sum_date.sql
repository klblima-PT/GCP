
-- ** orders_sum_date  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.refined_shipay.orders_sum_date`  AS bronze
USING (
  SELECT
    * --EXCEPT (rnk)
  FROM (
select origem, orders_created_date, orders_expiration_date, orders_payment_date, order_status, store_pos_id, wallet_name, 
psp_provider, wallet_type, orders_date_week,day_of_week, week_of_month, order_type, bolepix_payment_method, CURRENT_TIMESTAMP() AS last_refresh, created_at_date,
 count(order_id) as order_count, sum(orders_value) as orders_value
 from (
SELECT 
  'GCP' as origem,
  cast(DATETIME_SUB(DATETIME(a.created_at), INTERVAL 3 HOUR) as date)  AS orders_created_date,
  cast(DATETIME_SUB(DATETIME(a.expiration_date), INTERVAL 3 HOUR)as date) AS orders_expiration_date, 
  cast(DATETIME_SUB(DATETIME(a.payment_date), INTERVAL 3 HOUR)as date) AS orders_payment_date, 
  a.STATUS AS order_status,
  a.store_pos_id AS store_pos_id,
  b.wallet_name AS wallet_name,
  COALESCE(c.wallet_name, b.wallet_name) AS psp_provider,
  b.wallet_type AS wallet_type,
  0 AS orders_date_week,
  0 AS day_of_week, -- adjusted extraction
  0 AS week_of_month,
  a.type AS order_type,
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
psp_provider, wallet_type, orders_date_week,day_of_week, week_of_month, order_type, bolepix_payment_method,created_at_date

--union all
--
--SELECT 
--'AWS' as origem 
--   ,a.created_at AS orders_created_date
--  ,DATETIME_SUB(DATETIME(a.expiration_date), INTERVAL 3 HOUR) AS orders_expiration_date
--  ,DATETIME_SUB(DATETIME(a.payment_date), INTERVAL 3 HOUR) AS orders_payment_date
--	,a.STATUS AS order_status
--	,a.store_pos_id AS store_pos_id
--	,b.wallet_name AS wallet_name
--	,coalesce(c.wallet_name, b.wallet_name) AS psp_provider
--	,c.wallet_type AS wallet_type
--	,a.created_at  AS orders_date_week
--	--,EXTRACT(DOW FROM orders.created_at at TIME zone '-3') AS day_of_week
--	,a.created_at  AS week_of_month
--	,a.type AS order_type
--	,d.payment_method AS bolepix_payment_method
--	,current_timestamp() AS last_refresh
--	,count(a.id) AS order_count
--	,sum(SAFE_CAST(a.total_order AS FLOAT64) / 100) AS orders_value
--FROM `production-347022.trusted_shipay_aws.orders` a
--LEFT JOIN `production-347022.trusted_shipay_aws.system_wallets` b ON SAFE_CAST(a.wallet_id as string) = b.id
--LEFT JOIN `production-347022.trusted_shipay_aws.system_wallets` c ON SAFE_CAST(a.order_generated_by_wallet_id as string) = c.id
--LEFT JOIN `production-347022.trusted_shipay_aws.bank_slip` d ON SAFE_CAST(d.order_id as string) = a.id
--WHERE a.created_at >= current_date() -2
--GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13

)) AS raw

ON  bronze.store_pos_id 					    =	raw.store_pos_id 
	and bronze.orders_created_date =	raw.orders_created_date

WHEN MATCHED THEN UPDATE SET
 bronze.origem                  = raw.origem
,bronze.orders_created_date     = raw.orders_created_date
,bronze.orders_expiration_date  = raw.orders_expiration_date
,bronze.orders_payment_date     = raw.orders_payment_date
,bronze.order_status            = raw.order_status
,bronze.store_pos_id            = raw.store_pos_id
,bronze.wallet_name             = raw.wallet_name
,bronze.psp_provider            = raw.psp_provider
,bronze.wallet_type             = raw.wallet_type
,bronze.orders_date_week        = raw.orders_date_week
,bronze.day_of_week             = raw.day_of_week
,bronze.week_of_month           = raw.week_of_month
,bronze.order_type              = raw.order_type
,bronze.bolepix_payment_method  = raw.bolepix_payment_method
,bronze.last_refresh            = raw.last_refresh
,bronze.created_at_date         = raw.created_at_date
,bronze.order_count             = raw.order_count
,bronze.orders_value			= raw.orders_value



WHEN NOT MATCHED THEN INSERT (
 origem
,orders_created_date
,orders_expiration_date
,orders_payment_date
,order_status
,store_pos_id
,wallet_name
,psp_provider
,wallet_type
,orders_date_week
,day_of_week
,week_of_month
,order_type
,bolepix_payment_method
,last_refresh
,created_at_date
,order_count
,orders_value

)
VALUES (

 raw.origem
,raw.orders_created_date
,raw.orders_expiration_date
,raw.orders_payment_date
,raw.order_status
,raw.store_pos_id
,raw.wallet_name
,raw.psp_provider
,raw.wallet_type
,raw.orders_date_week
,raw.day_of_week
,raw.week_of_month
,raw.order_type
,raw.bolepix_payment_method
,raw.last_refresh
,raw.created_at_date
,raw.order_count
,raw.orders_value						
--,CURRENT_DATETIME('-03:00')
);
insert into `production-347022.refined_shipay.orders_sum_time` 

SELECT
    * ,
   
  FROM (

SELECT 
  'GCP' as origem 
	,a.created_at as  orders_created_date   
  ,DATETIME_SUB(DATETIME(a.payment_date), INTERVAL 3 HOUR) AS orders_payment_date
	,a.STATUS AS order_status
	,a.store_pos_id AS store_pos_id
	,b.wallet_name AS wallet_name
	,coalesce(c.wallet_name, b.wallet_name) AS psp_provider
	,c.wallet_type AS wallet_type
	,a.created_at AS orders_date_week
	,a.created_at AS day_of_week
	,a.created_at AS week_of_month
	,a.type AS order_type
	,a.wallet_setting_id AS wallet_setting_id
	,d.payment_method AS bolepix_payment_method
	,current_timestamp() AS last_refresh
	,a.created_at_date
	 ,ROW_NUMBER() OVER(PARTITION BY  a.store_pos_id, a.created_at ORDER BY a.dt_carga_trusted DESC) AS rnk
	,count(a.id) AS order_count
	,sum(safe_cast(a.total_order AS FLOAT64) / 100) AS orders_value
FROM `production-347022.trusted_shipay.orders` a
LEFT JOIN `production-347022.trusted_shipay.system_wallets` b ON a.wallet_id  = b.id
LEFT JOIN `production-347022.trusted_shipay.system_wallets` c  ON a.order_generated_by_wallet_id  = c.id
LEFT JOIN `production-347022.trusted_shipay.bank_slip` d ON d.order_id  = a.id
--WHERE --a.created_at_date = current_date()
--and SAFE_CAST(a.updated_at AS DATETIME) between  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 100 HOUR) 
--    AND  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 1 HOUR)
--(to_date(to_char((current_timestamp at TIME zone '3') - interval '7 days', 'YYYY-MM-DD'), 'YYYY-MM-DDThh24:mi:ss') at TIME zone '-3')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13, 14,15,16
 )
WHERE
    rnk = 1


union all
SELECT
    * ,
   
  FROM (
SELECT 
  'AWS' as origem, 
	a.created_at orders_created_date
	,DATETIME_SUB(DATETIME(a.payment_date), INTERVAL 3 HOUR) AS orders_payment_date 
	,a.STATUS AS order_status
	,a.store_pos_id AS store_pos_id
	,b.wallet_name AS wallet_name
	,coalesce(c.wallet_name, b.wallet_name) AS psp_provider
	,c.wallet_type AS wallet_type
	,a.created_at AS orders_date_week
	,a.created_at AS day_of_week
	,a.created_at  AS week_of_month
	,a.type AS order_type
	,a.wallet_setting_id AS wallet_setting_id
	,d.payment_method AS bolepix_payment_method
	,current_timestamp() AS last_refresh
		,a.created_at_date
	 ,ROW_NUMBER() OVER(PARTITION BY a.store_pos_id, a.created_at ORDER BY a.dt_carga_trusted DESC) AS rnk
	,count(a.id) AS order_count
	,sum(safe_cast(a.total_order AS FLOAT64) / 100) AS orders_value
FROM `production-347022.trusted_shipay_aws.orders` a
LEFT JOIN `production-347022.trusted_shipay_aws.system_wallets` b ON a.wallet_id  = b.id
LEFT JOIN `production-347022.trusted_shipay_aws.system_wallets` c  ON a.order_generated_by_wallet_id  = c.id
LEFT JOIN `production-347022.trusted_shipay_aws.bank_slip` d ON d.order_id  = a.id
--WHERE a.created_at_date = current_date()
--and SAFE_CAST(a.updated_at AS DATETIME) between  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR) 
    --AND  DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 1 HOUR)
--WHERE a.created_at >= (to_date(to_char((current_timestamp at TIME zone '3') - interval '7 days', 'YYYY-MM-DD'), 'YYYY-MM-DDThh24:mi:ss') at TIME zone '-3')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13, 14,15,16
ORDER BY store_pos_id,orders_created_date
 )
WHERE
    rnk = 1
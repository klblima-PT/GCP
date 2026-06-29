CREATE or replace VIEW `production-347022.refined_shipay.tb_mv_orders` AS

SELECT 
   timestamp(a.created_at, 'southamerica-east1')  AS orders_created_date
	,datetime(a.expiration_date, 'southamerica-east1')  AS orders_expiration_date
	,datetime(a.payment_date, 'southamerica-east1')  AS orders_payment_date
	,a.STATUS AS order_status
	,a.store_pos_id AS store_pos_id
	,b.wallet_name AS wallet_name
	,coalesce(c.wallet_name, b.wallet_name) AS psp_provider
	,c.wallet_type AS wallet_type
	,timestamp(a.created_at,'southamerica-east1')  AS orders_date_week
	--,EXTRACT(DOW FROM orders.created_at at TIME zone '-3') AS day_of_week
	,timestamp(a.created_at, 'southamerica-east1') AS week_of_month
	,a.type AS order_type
	,d.payment_method AS bolepix_payment_method
	,current_timestamp() AS last_refresh
	,count(a.id) AS order_count
	,sum(SAFE_CAST(a.total_order AS FLOAT64) / 100) AS orders_value
FROM `production-347022.trusted_shipay.orders` a
LEFT JOIN `production-347022.trusted_shipay.system_wallets` b ON SAFE_CAST(a.wallet_id as string) = b.id
LEFT JOIN `production-347022.trusted_shipay.system_wallets` c ON SAFE_CAST(a.order_generated_by_wallet_id as string) = c.id
LEFT JOIN `production-347022.trusted_shipay.bank_slip` d ON SAFE_CAST(d.order_id as string) = a.id
WHERE a.created_at >= datetime(current_timestamp , 'southamerica-east1') --- interval '1 days', 'YYYY-MM-DD'), 'YYYY-MM-DDThh24:mi:ss') at TIME zone '-3')
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13

	
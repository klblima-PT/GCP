CREATE MATERIALIZED VIEW mv_orders_time AS

SELECT to_timestamp(to_char(orders.created_at at TIME zone '-3', 'YYYY-MM-DD hh24:00:00'), 'YYYY-MM-DD hh24:mi:ss') AS orders_created_date
	,to_date(to_char(orders.payment_date at TIME zone '-3', 'YYYY-MM-DD'), 'YYYY-MM-DD') AS orders_payment_date
	,orders.STATUS AS order_status
	,orders.store_pos_id AS store_pos_id
	,system_wallets.wallet_name AS wallet_name
	,coalesce(system_wallets2.wallet_name, system_wallets.wallet_name) AS psp_provider
	,system_wallets2.wallet_type AS wallet_type
	,to_char(orders.created_at at TIME zone '-3', 'IW') AS orders_date_week
	,EXTRACT(DOW FROM orders.created_at at TIME zone '-3') AS day_of_week
	,to_char((orders.created_at at TIME zone '-3')::TIMESTAMP, 'W') AS week_of_month
	,count(orders.id) AS order_count
	,sum(CAST(orders.total_order AS FLOAT) / 100) AS orders_value
	,orders.type AS order_type
	,orders.wallet_setting_id AS wallet_setting_id
	,bank_slip.payment_method AS bolepix_payment_method
	,current_timestamp AS last_refresh
FROM orders
LEFT JOIN system_wallets ON orders.wallet_id = system_wallets.id
LEFT JOIN system_wallets system_wallets2 ON orders.order_generated_by_wallet_id = system_wallets2.id
LEFT JOIN bank_slip ON bank_slip.order_id = orders.id
WHERE orders.created_at >= (to_date(to_char((current_timestamp at TIME zone '3') - interval '7 days', 'YYYY-MM-DD'), 'YYYY-MM-DDThh24:mi:ss') at TIME zone '-3')
GROUP BY order_status
	,system_wallets.wallet_name
	,orders_date_week
	,day_of_week
	,day_of_week
	,week_of_month
	,psp_provider
	,system_wallets2.wallet_type
	,orders_created_date
	,orders_payment_date
	,orders.store_pos_id
	,orders.type
	,orders.wallet_setting_id
	,bank_slip.payment_method
ORDER BY store_pos_id
	,orders_created_date;

CREATE INDEX idx_mv_orders_time_created ON PUBLIC.mv_orders_time USING btree (orders_created_date);
CREATE INDEX idx_mv_orders_time_psp ON PUBLIC.mv_orders_time USING btree (psp_provider);
CREATE INDEX idx_mv_orders_time_status ON PUBLIC.mv_orders_time USING btree (order_status);
CREATE INDEX idx_mv_orders_time_store_pos ON PUBLIC.mv_orders_time USING btree (store_pos_id);
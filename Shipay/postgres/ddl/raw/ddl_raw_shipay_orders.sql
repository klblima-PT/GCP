
CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay.orders` (
	id string  ,
	created_at string ,
	updated_at string  ,
	uuid string ,
	total_order string ,
	external_id string  ,
	status string  ,
	wallet_payment string ,
	authorization_id string ,
	cancellation_id string ,
	refund_id string ,
	wallet_order_id string ,
	buyer_id string ,
	wallet_id string ,
	store_pos_id string ,
	meta_data string ,
	callback_url string ,
	wallet_payment_id string ,
	expiration_date string ,
	payment_date string ,
	order_generated_by_wallet_id string ,
	type string ,
	wallet_setting_id string ,
	balance string ,
	installments string ,
	payer_id string ,
	created_at_date date, 
	dt_carga_raw timestamp,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY  uuid,created_at, buyer_id, updated_at
    

OPTIONS (
  DESCRIPTION = 'Table orders T clustered by  uuid,created_at, buyer_id, updated_at'
); 
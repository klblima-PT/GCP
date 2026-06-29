
CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay_aws.orders` (
	id int64  ,
	created_at timestamp ,
	updated_at timestamp ,
	created_at_date date ,
	uuid string,
	total_order int64 ,
	external_id string ,
	status string,
	wallet_payment int64 ,
	authorization_id string ,
	cancellation_id string ,
	refund_id string ,
	wallet_order_id string ,
	buyer_id int64 ,
	wallet_id int64 ,
	store_pos_id int64 ,
	meta_data string ,
	callback_url string ,
	wallet_payment_id string ,
	expiration_date timestamp ,
	payment_date timestamp ,
	order_generated_by_wallet_id int64 ,
	type string ,
	wallet_setting_id int64 ,
	balance int64 ,
	installments int64 ,
	payer_id int64 ,
	dt_carga_trusted DATETIME,
	
 PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY uuid, created_at, external_id,status
    

OPTIONS (
  DESCRIPTION = 'Table orders T clustered by degree'
); 
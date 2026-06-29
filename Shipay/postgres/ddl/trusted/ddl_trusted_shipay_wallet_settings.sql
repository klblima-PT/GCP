CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay.wallet_settings` (
	id int64  ,
	uuid string,
	created_at timestamp ,
	updated_at timestamp , 
	created_at_date date,
	active bool , 
	wallet_id int64 , 
	--default_ bool , 
	name string ,
	customer_id int64 , 
	psp_provider_id int64 , 
	pix_dict_key string ,
	transaction_type string ,
	bank_slip_settings_id int64 , 
	withdraw_bank_id int64 , 
	dt_carga_trusted DATETIME,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY uuid
    

OPTIONS (
  DESCRIPTION = 'Table wallet_settings T clustered by uuid'
); 
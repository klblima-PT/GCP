CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay_aws.wallet_settings` (
	id string ,
	uuid string ,
	created_at string ,
	updated_at string  ,
	created_at_date date ,
	active string ,
	wallet_id string ,
	--default_ string   ,
	name string ,
	customer_id string ,
	psp_provider_id string ,
	pix_dict_key string ,
	transaction_type string ,
	bank_slip_settings_id string ,
	withdraw_bank_id string ,
	dt_carga_raw timestamp,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY uuid
    

OPTIONS (
  DESCRIPTION = 'Table wallet_settings T clustered by uuid'
); 
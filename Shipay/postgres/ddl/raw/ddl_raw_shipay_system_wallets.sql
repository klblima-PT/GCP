CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay.system_wallets` (
	id string ,
	wallet_name string ,
	active string ,
	payment_fee string ,
	minimum_payment string ,
	require_settings string ,
	wallet_type string ,
	single_credentials string ,
	wallet_friendly_name string ,
	wallet_logo string ,
	icon string ,
	uuid string ,
	cashout_active string  ,
	dt_carga_raw timestamp,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY uuid
    

OPTIONS (
  DESCRIPTION = 'Table system_wallets T clustered by uuid'
); 
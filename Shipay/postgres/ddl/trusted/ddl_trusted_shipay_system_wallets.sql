CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay.system_wallets` (
	id int64  ,
	wallet_name string ,
	active bool ,
	payment_fee float64 , 
	minimum_payment float64 , 
	require_settings bool , 
	wallet_type string ,
	single_credentials bool , 
	wallet_friendly_name string ,
	wallet_logo string ,
	icon string ,
	uuid string,
	cashout_active bool , 
	dt_carga_trusted DATETIME,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY uuid
    

OPTIONS (
  DESCRIPTION = 'Table system_wallets T clustered by degree '
); 
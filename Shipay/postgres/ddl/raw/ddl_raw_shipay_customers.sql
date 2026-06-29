CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay.customers` (
	id string ,
	uuid string ,
	name string ,
	email string ,
	access_key string ,
	secret_key string ,
	degree string ,
	created_at string ,
	updated_at string  ,
	created_at_date date, 
	access_key_reference string ,
	secret_key_reference string ,
	external_crm_id string,
	dt_carga_raw timestamp,
	
  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY id
    

OPTIONS (
  DESCRIPTION = 'Table customers T clustered by id'
); 
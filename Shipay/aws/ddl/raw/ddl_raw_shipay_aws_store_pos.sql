CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay_aws.store_pos` (
	id string ,
	created_at string ,
	updated_at string  ,
	created_at_date date ,
	name string ,
	active string ,
	uuid string ,
	fixed_amount string ,
	meta_data string ,
	store_id string ,
	category string,
	client_token_reference string ,
	dt_carga_raw timestamp,
  PRIMARY KEY   (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY client_token_reference,name,store_id
    

OPTIONS (
  DESCRIPTION = 'Table store_pos T clustered by client_token_reference,name,store_id'
); 
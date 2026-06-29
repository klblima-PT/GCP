CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay.store_pos` (
	id int64  ,
	created_at timestamp ,
	updated_at timestamp ,
	created_at_date date ,
	name string ,
	active bool , 
	uuid string,
	fixed_amount bool ,  
	meta_data string ,
	store_id int64 , 
	category string,
	client_token_reference int64 , 
	dt_carga_trusted DATETIME,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY client_token_reference, name, store_id
    

OPTIONS (
  DESCRIPTION = 'Table store_pos T clustered by client_token_reference, name, store_id '
); 
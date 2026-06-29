CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay.buyers` (
	id string ,
	created_at string ,
	updated_at string ,
	first_name string ,
	last_name string ,
	document string ,
	email string ,
	phone string ,
	address string ,
  address_city_id string,
	created_at_date date, 
	dt_carga_raw timestamp,
	 

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY id
    

OPTIONS (
  DESCRIPTION = 'Table buyers T clustered by id, document'
); 
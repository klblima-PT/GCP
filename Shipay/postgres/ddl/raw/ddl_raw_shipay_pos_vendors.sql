CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay.pos_vendors` (
	id string ,
	uuid string ,
	name string ,
	cnpj string ,
	email string ,
	active string ,
	created_at string ,
	updated_at string  ,
	created_at_date date, 
	degree string ,
	external_crm_id string ,
	dt_carga_raw timestamp,
 PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY degree
    

OPTIONS (
  DESCRIPTION = 'Table pos_vendors T clustered by degree'
); 
CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay.retail_chains` (
	id string  ,
	name string ,
	uuid string ,
	email string ,
	degree string ,
	created_at string ,
	updated_at string  ,
	created_at_date date, 
	external_crm_id string ,
	dt_carga_raw timestamp,
  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY degree
    

OPTIONS (
  DESCRIPTION = 'Table retail_chains T clustered by degree'
); 


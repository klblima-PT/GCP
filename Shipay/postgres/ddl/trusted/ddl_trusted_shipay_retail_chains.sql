CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay.retail_chains` (
	id int64 ,
	name string ,
	uuid string ,
	email string ,
	degree string ,
	created_at timestamp ,
	updated_at timestamp  ,
	created_at_date date ,
	external_crm_id string ,
	dt_carga_trusted DATETIME,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY degree
    

OPTIONS (
  DESCRIPTION = 'Table retail_chains T clustered by degree'
); 
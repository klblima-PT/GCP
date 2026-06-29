CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay_aws.pos_vendors` (
	id int64 ,
	uuid string,
	name string,
	cnpj string,
	email string,
	active bool , 
	created_at timestamp ,  
	updated_at timestamp , 
	created_at_date date, 
	degree string,
	external_crm_id string,
	dt_carga_trusted DATETIME,  

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY degree
    

OPTIONS (
  DESCRIPTION = 'Table pos_vendors T clustered by degree'
); 
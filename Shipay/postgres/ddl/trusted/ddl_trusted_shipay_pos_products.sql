CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay.pos_products` (
	id int64  ,
	uuid string,
	name string ,
	email string ,
	pos_vendor_id int64 , 
	active bool , 
	created_at timestamp ,
	updated_at timestamp ,
	created_at_date date, 
	degree string ,
	fake_register bool , 
	notify bool ,
	logo string ,
	external_crm_id string ,
	dt_carga_trusted DATETIME, 

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY degree, pos_vendor_id
    

OPTIONS (
  DESCRIPTION = 'Table pos_products T clustered by degree, pos_vendor_id'
); 
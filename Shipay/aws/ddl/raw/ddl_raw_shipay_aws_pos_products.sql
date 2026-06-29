CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay_aws.pos_products` (
	id string ,
	uuid string ,
	name string ,
	email string ,
	pos_vendor_id string  ,
	active string ,
	created_at string ,
	updated_at string  ,
	created_at_date date, 
	degree string  ,
	fake_register string ,
	notify string ,
	logo string ,
	external_crm_id string ,
	dt_carga_raw timestamp,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY degree,pos_vendor_id
    

OPTIONS (
  DESCRIPTION = 'Table pos_products T clustered by order_id'
); 
	
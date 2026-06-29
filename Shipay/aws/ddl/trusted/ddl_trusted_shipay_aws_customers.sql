CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay_aws.customers` (
	id int64  ,
	uuid string,
	name string ,
	email string ,
	access_key string ,
	secret_key string ,
	degree string ,
	created_at timestamp ,
	updated_at timestamp , 
	created_at_date date, 
	access_key_reference int64 ,
	secret_key_reference int64 ,
	external_crm_id string ,
	dt_carga_trusted DATETIME,
  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY access_key_reference,degree
    

OPTIONS (
  DESCRIPTION = 'Table customers T clustered by access_key_reference,degree'
); 
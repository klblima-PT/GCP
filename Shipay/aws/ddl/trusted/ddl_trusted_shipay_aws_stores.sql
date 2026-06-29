CREATE TABLE IF NOT EXISTS  `production-347022.trusted_shipay_aws.stores` (
	id int64  ,
	created_at timestamp ,
	updated_at timestamp , 
	created_at_date date, 
	name string ,
	uuid string,
	active bool ,  
	zip_code string ,
	street_name string ,
	street_number string ,
	city_name string ,
	state_name string ,
	latitude float64 ,  
	longitude float64 ,  
	reference string ,
	meta_data string ,
	customer_id int64 ,  
	cnpj_cpf string ,
	headquarter bool ,  
	degree string ,
	person_type string ,
	neighborhood string ,
	zendesk_deal_id int64 ,  
	dt_carga_trusted DATETIME,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY customer_id, degree, name
    

OPTIONS (
  DESCRIPTION = 'Table stores T clustered by customer_id, degree, name'
); 
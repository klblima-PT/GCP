CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay_aws.stores` (
	id string ,
	created_at string ,
	updated_at string  ,
	created_at_date date ,
	name string ,
	uuid string ,
	active string ,
	zip_code string,
	street_name string ,
	street_number string ,
	city_name string ,
	state_name string ,
	latitude string ,
	longitude string ,
	reference string ,
	meta_data string ,
	customer_id string ,
	cnpj_cpf string ,
	headquarter string ,
	degree string ,
	person_type string ,
	neighborhood string ,
	zendesk_deal_id string ,
dt_carga_raw timestamp,
  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY id, cnpj_cpf, degree, customer_id
    

OPTIONS (
  DESCRIPTION = 'Table customers T clustered by id'
); 

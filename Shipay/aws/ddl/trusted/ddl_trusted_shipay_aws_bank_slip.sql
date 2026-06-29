 CREATE TABLE IF NOT EXISTS `production-347022.trusted_shipay_aws.bank_slip` (
	id string ,
	uuid string,
	external_id string,
	created_at timestamp ,
	updated_at timestamp ,
	created_at_date date ,
	expire_date timestamp ,
	payment_code int64 , 
	total_amount int64 , 
	rebate_amount int64 ,
	days_until_expiration int64 , 
	days_until_negation int64 ,
	order_id int64 , 
	covenant_code string,
	days_valid_after_due int64 , 
	payment_method string ,
	dt_carga_trusted timestamp,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY order_id
    

OPTIONS (
  DESCRIPTION = 'Table bank_slip T clustered by order_id'
); 
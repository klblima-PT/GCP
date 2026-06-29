CREATE TABLE IF NOT EXISTS  `production-347022.raw_shipay_aws.bank_slip` (
	id string ,
	uuid string ,
	external_id string ,
	created_at string  ,
	updated_at string ,
	created_at_date date, 
	expire_date string ,
	payment_code string ,
	total_amount string ,
	rebate_amount string ,
	days_until_expiration string ,
	days_until_negation string ,
	order_id string ,
	covenant_code string ,
	days_valid_after_due string ,
	payment_method string ,
	dt_carga_raw timestamp,

  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY created_at_date -- Replace by Client options sent

CLUSTER BY order_id
    

OPTIONS (
  DESCRIPTION = 'Table bank_slip T clustered by order_id'
); 
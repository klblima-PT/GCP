
-- ** bank_slip  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay.bank_slip` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
id  ,
	uuid ,
	external_id ,
	 safe_cast(created_at as timestamp) as  created_at , 
	safe_cast(updated_at as timestamp) as  updated_at ,
	safe_cast(created_at_date as date) as  created_at_date , 
	safe_cast(expire_date as timestamp) as expire_date  ,
	safe_cast(payment_code as int64)  as payment_code,
	safe_cast(total_amount as int64) as total_amount,
	safe_cast(rebate_amount as int64) as rebate_amount,
	safe_cast(days_until_expiration as int64) as days_until_expiration,
	safe_cast(days_until_negation as int64) days_until_negation,
	safe_cast(order_id as int64) as order_id,
	covenant_code ,
	safe_cast(days_valid_after_due as int64) as days_valid_after_due,
	payment_method ,
	dt_carga_raw   ,

     
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY order_id DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay.bank_slip`
     WHERE created_at_date = current_date()
    AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR) 
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id  						    =	raw.id  ,
bronze.uuid 					    =	raw.uuid ,
bronze.external_id 				=	raw.external_id ,
bronze.created_at  				=	raw.created_at  ,
bronze.updated_at  				=	raw.updated_at  ,
bronze.created_at_date  				=	raw.created_at_date  ,
bronze.expire_date  			=	raw.expire_date  ,
bronze.payment_code 			=	raw.payment_code  ,
bronze.total_amount 			=	raw.total_amount  ,
bronze.rebate_amount 			=	raw.rebate_amount  ,
bronze.days_until_expiration 	=	raw.days_until_expiration  ,
bronze.days_until_negation 		=	raw.days_until_negation   ,
bronze.order_id					  =	raw.order_id  ,
bronze.covenant_code 			=	raw.covenant_code ,
bronze.days_valid_after_due 	=	raw.days_valid_after_due  ,
bronze.payment_method 				    = 	raw.payment_method 


WHEN NOT MATCHED THEN INSERT (
  id  ,
	uuid ,
	external_id ,
	created_at  ,
	updated_at  ,
	created_at_date,
	expire_date  ,
	payment_code,
	total_amount,
	rebate_amount,
	days_until_expiration,
	days_until_negation,
	order_id,
	covenant_code ,
	days_valid_after_due,
	payment_method ,
	dt_carga_trusted     

)
VALUES (
 raw.id  					
,raw.uuid 				
,raw.external_id 			
,raw.created_at  			
,raw.updated_at  
,raw.created_at_date			
,raw.expire_date  		
,raw.payment_code 		
,raw.total_amount 		
,raw.rebate_amount 		
,raw.days_until_expiration 
,raw.days_until_negation 	
,raw.order_id				
,raw.covenant_code 		
,raw.days_valid_after_due 
,raw.payment_method 						
,CURRENT_DATETIME('-03:00')
);
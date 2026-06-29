
-- ** orders  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay_aws.orders` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
	safe_cast(id as int64) as id   				
, safe_cast(created_at as timestamp) as created_at   
	,safe_cast(updated_at as timestamp) as updated_at   
	,created_at_date
,uuid 				
,safe_cast(total_order as int64)   	as total_order	
,external_id  		
,status 				
,safe_cast(wallet_payment as int64) 	wallet_payment
,authorization_id  	
,cancellation_id  	
,refund_id  			
,wallet_order_id  	
,	safe_cast(buyer_id as int64)  as buyer_id  			
,safe_cast(wallet_id as int64) as wallet_id  			
,safe_cast(store_pos_id as int64) as store_pos_id  		
,meta_data  			
,callback_url  		
,wallet_payment_id  	
,safe_cast(expiration_date as timestamp) as expiration_date  	
,safe_cast(payment_date  as timestamp) as payment_date  		
,safe_cast(order_generated_by_wallet_id as int64) as order_generated_by_wallet_id
,type  				
,safe_cast(wallet_setting_id as int64) as  wallet_setting_id  	
,safe_cast(balance as int64) as balance  			
,safe_cast(installments as int64)as installments  		
,safe_cast(payer_id as int64)as payer_id  			
,dt_carga_raw	
,
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY uuid, created_at, external_id,status DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay_aws.orders`
      WHERE created_at_date = current_date()
        AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR)
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id   				=	      raw.id   ,
bronze.created_at  			=	safe_cast(raw.created_at as timestamp),
bronze.updated_at  				=	safe_cast(raw.updated_at as timestamp)   ,
bronze.created_at_date  			=	raw.created_at_date ,
bronze.uuid 				=	raw.uuid ,
bronze.total_order  		=	safe_cast(raw.total_order as int64) ,
bronze.external_id  		=	raw.external_id  ,
bronze.status 				=	raw.status ,
bronze.wallet_payment  		=	safe_cast(raw.wallet_payment as int64) ,
bronze.authorization_id  	=	raw.authorization_id  ,
bronze.cancellation_id  	=	raw.cancellation_id  ,
bronze.refund_id  			=	raw.refund_id  ,
bronze.wallet_order_id  	=	raw.wallet_order_id  ,
bronze.buyer_id  			=	safe_cast(raw.buyer_id as int64)  ,
bronze.wallet_id  			=	safe_cast(raw.wallet_id as int64)  ,
bronze.store_pos_id  		=	safe_cast(raw.store_pos_id as int64)  ,
bronze.meta_data  			=	raw.meta_data  ,
bronze.callback_url  		=	raw.callback_url  ,
bronze.wallet_payment_id  	=	raw.wallet_payment_id  ,
bronze.expiration_date  		=	safe_cast(raw.expiration_date as timestamp)  ,
bronze.payment_date  			=	safe_cast(raw.payment_date  as timestamp)   ,
bronze.order_generated_by_wallet_id  =	safe_cast(raw.order_generated_by_wallet_id as int64),
bronze.type  				=	raw.type  ,
bronze.wallet_setting_id  	=	safe_cast(raw.wallet_setting_id as int64)  ,
bronze.balance  			=	safe_cast(raw.balance as int64) ,
bronze.installments  		=	safe_cast(raw.installments as int64) ,
bronze.payer_id  			=	safe_cast(raw.payer_id as int64) 
													

WHEN NOT MATCHED THEN INSERT (
 id   				
,created_at  		
,updated_at  
,created_at_date		
,uuid 				
,total_order  		
,external_id  		
,status 				
,wallet_payment  	
,authorization_id  	
,cancellation_id  	
,refund_id  			
,wallet_order_id  	
,buyer_id  			
,wallet_id  			
,store_pos_id  		
,meta_data  			
,callback_url  		
,wallet_payment_id  	
,expiration_date  	
,payment_date  		
,order_generated_by_wallet_id
,type  				
,wallet_setting_id  	
,balance  			
,installments  		
,payer_id  			
,dt_carga_trusted

)
VALUES (
raw.id   ,
	raw.created_at  ,
	raw.updated_at  ,
	raw.created_at_date,
	raw.uuid ,
	raw.total_order  ,
	raw.external_id  ,
	raw.status ,
	raw.wallet_payment  ,
	raw.authorization_id  ,
	raw.cancellation_id  ,
	raw.refund_id  ,
	raw.wallet_order_id  ,
	raw.buyer_id  ,
	raw.wallet_id  ,
	raw.store_pos_id  ,
	raw.meta_data  ,
	raw.callback_url  ,
	raw.wallet_payment_id  ,
	raw.expiration_date  ,
	raw.payment_date  ,
	raw.order_generated_by_wallet_id  ,
	raw.type  ,
	raw.wallet_setting_id  ,
	raw.balance  ,
	raw.installments  ,
	raw.payer_id  ,
CURRENT_DATETIME('-03:00')
);

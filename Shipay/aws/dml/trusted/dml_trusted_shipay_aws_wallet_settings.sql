
-- ** system_wallets  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay_aws.wallet_settings` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
safe_cast(id as int64) as id ,
	uuid  ,
	 safe_cast(created_at as timestamp) as created_at   ,
	safe_cast(updated_at as timestamp) as updated_at   ,
	created_at_date, 
	safe_cast(active as bool) as active  ,
	safe_cast(wallet_id as int64) wallet_id  ,
	--safe_cast(default_ as bool) as default   ,
	name  ,
	safe_cast(customer_id as int64) as customer_id  ,
	safe_cast(psp_provider_id as int64) as psp_provider_id  ,
	pix_dict_key  ,
	transaction_type  ,
	safe_cast(bank_slip_settings_id as int64) as bank_slip_settings_id  ,
	safe_cast(withdraw_bank_id as int64) as withdraw_bank_id  ,
dt_carga_raw , 
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY uuid DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay_aws.wallet_settings`
    WHERE created_at_date = current_date()
    AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR)
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id  		=	raw.id  ,
bronze.uuid  		=	raw.uuid  ,
bronze.created_at  =			raw.created_at  ,
bronze.updated_at  = 			raw.updated_at   ,
bronze.created_at_date  =			raw.created_at_date  ,
bronze.active  	=		raw.active  ,
bronze.wallet_id  	=		raw.wallet_id  ,
--raw.default_    =			raw.default_    
bronze.name  		=	raw.name  ,
bronze.customer_id = 			raw.customer_id  ,
bronze.psp_provider_id =  			raw.psp_provider_id  ,
bronze.pix_dict_key  	= 		raw.pix_dict_key  ,
bronze.transaction_type = 			raw.transaction_type , 
bronze.bank_slip_settings_id	=		raw.bank_slip_settings_id  ,
bronze.withdraw_bank_id  		=	raw.withdraw_bank_id  


WHEN NOT MATCHED THEN INSERT (
id  ,
	uuid  ,
	created_at  ,
	updated_at   ,
	created_at_date,
	active  ,
	wallet_id  ,
	--default_    ,
	name  ,
	customer_id  ,
	psp_provider_id  ,
	pix_dict_key  ,
	transaction_type  ,
	bank_slip_settings_id  ,
	withdraw_bank_id  ,
dt_carga_trusted 

)
VALUES (
	raw.id  ,
	raw.uuid  ,
	raw.created_at  ,
	raw.updated_at   ,
	raw.created_at_date,
	raw.active  ,
	raw.wallet_id  ,
--	raw.default_    ,
	raw.name  ,
	raw.customer_id  ,
	raw.psp_provider_id  ,
	raw.pix_dict_key  ,
	raw.transaction_type  ,
	raw.bank_slip_settings_id  ,
	raw.withdraw_bank_id  ,
	CURRENT_DATETIME('-03:00')
);

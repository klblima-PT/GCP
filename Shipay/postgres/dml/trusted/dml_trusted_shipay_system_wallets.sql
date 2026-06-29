
-- ** system_wallets  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay.system_wallets` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
safe_cast(id as int64) as id,  
wallet_name  ,
safe_cast(active as  bool) as  active  ,
safe_cast(payment_fee as float64) as payment_fee  ,
safe_cast(minimum_payment as float64) as minimum_payment  ,
safe_cast( require_settings as bool) as require_settings  ,
wallet_type  ,
safe_cast(single_credentials as bool) as single_credentials  ,
wallet_friendly_name  ,
wallet_logo  ,
icon  ,
uuid  ,
safe_cast(cashout_active as  bool) as  cashout_active ,
dt_carga_raw,

      ROW_NUMBER() OVER(PARTITION BY id ORDER BY uuid DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay.system_wallets`
  --WHERE created_at_date = current_date()
   -- AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR) 
   -- AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR)  
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id                       =   raw.id   ,                
bronze.wallet_name              =   raw.wallet_name  ,        
bronze.active                   =   raw.active      ,         
bronze.payment_fee              =   raw.payment_fee     ,     
bronze.minimum_payment          =   raw.minimum_payment    ,  
bronze.require_settings         =   raw.require_settings  ,   
bronze.wallet_type              =   raw.wallet_type       ,   
bronze.single_credentials       =   raw.single_credentials   ,
bronze.wallet_friendly_name     =   raw.wallet_friendly_name ,
bronze.wallet_logo              =   raw.wallet_logo     ,     
bronze.icon                     =   raw.icon     ,            
bronze.uuid                     =   raw.uuid     ,            
bronze.cashout_active           =   raw.cashout_active  


WHEN NOT MATCHED THEN INSERT (
id  ,
wallet_name  ,
active  ,
payment_fee  ,
minimum_payment  ,
require_settings  ,
wallet_type  ,
single_credentials , 
wallet_friendly_name , 
wallet_logo  ,
icon  ,
uuid  ,
cashout_active,
dt_carga_trusted 

)
VALUES (
raw.id  ,
raw.wallet_name  ,
raw.active  ,
raw.payment_fee  ,
raw.minimum_payment  ,
raw.require_settings  ,
raw.wallet_type  ,
raw.single_credentials  ,
raw.wallet_friendly_name , 
raw.wallet_logo  ,
raw.icon  ,
raw.uuid  ,
raw.cashout_active  ,
CURRENT_DATETIME('-03:00')
);

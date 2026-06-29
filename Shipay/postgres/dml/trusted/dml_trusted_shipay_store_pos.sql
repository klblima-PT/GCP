
-- ** store_pos  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay.store_pos` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
safe_cast(id as int64) as id ,
safe_cast(created_at as timestamp) as created_at,
safe_cast(updated_at as timestamp) as updated_at   ,
created_at_date, 
name ,
safe_cast(active as bool) as active  ,
uuid  ,
safe_cast(fixed_amount as bool) as fixed_amount  ,
meta_data  ,
safe_cast(store_id as int64) as store_id  ,
category ,
 safe_cast(client_token_reference as int64) as client_token_reference  ,
dt_carga_raw,

     
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY client_token_reference,name,store_id DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay.store_pos`
 WHERE created_at_date = current_date()
    AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR)  
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id                       =   raw.id                      ,
bronze.created_at               =   raw.created_at              ,
bronze.updated_at               =   raw.updated_at              ,
bronze.created_at_date          =   raw.created_at_date              ,
bronze.name                     =   raw.name                    ,
bronze.active                   =   raw.active                  ,
bronze.uuid                     =   raw.uuid                    ,
bronze.fixed_amount             =   raw.fixed_amount            ,
bronze.meta_data                =   raw.meta_data               ,
bronze.store_id                 =   raw.store_id                ,
bronze.category                 =   raw.category                ,
bronze.client_token_reference   =   raw.client_token_reference  


WHEN NOT MATCHED THEN INSERT (
id  ,
created_at  ,
updated_at   ,
created_at_date,
name ,
active  ,
uuid  ,
fixed_amount  ,
meta_data  ,
store_id  ,
category ,
client_token_reference  ,
dt_carga_trusted 

)
VALUES (
raw.id  ,
raw.created_at  ,
raw.updated_at   ,
raw.created_at_date,
raw.name ,
raw.active  ,
raw.uuid  ,
raw.fixed_amount  ,
raw.meta_data  ,
raw.store_id  ,
raw.category ,
raw.client_token_reference  ,
CURRENT_DATETIME('-03:00')
);

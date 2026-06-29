
-- ** customers  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay_aws.customers` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
  safe_cast(id as int64) as id ,
uuid ,
name  ,
email  ,
access_key  ,
secret_key  ,
degree  ,
safe_cast(created_at as timestamp) as created_at   ,
safe_cast(updated_at as timestamp) as updated_at   ,
	created_at_date, 
safe_cast(access_key_reference as int64) as access_key_reference ,
safe_cast(secret_key_reference as int64) as secret_key_reference  ,
external_crm_id  ,
dt_carga_raw,
      
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY access_key_reference,degree DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay_aws.customers`
  WHERE created_at_date = current_date()
       AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR)
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id    		=		      raw.id    	,
bronze.uuid 		=		      raw.uuid 	,
bronze.name  		=		      raw.name  	,
bronze.email  	=			    raw.email  	,
bronze.access_key = 			raw.access_key  	,
bronze.secret_key  =			raw.secret_key  	,
bronze.degree  		=		    raw.degree  	,
bronze.created_at  =			raw.created_at  ,
bronze.updated_at  =			raw.updated_at  	,
bronze.created_at_date  = raw.created_at_date  ,
bronze.access_key_reference = safe_cast(raw.access_key_reference as int64),
bronze.secret_key_reference = safe_cast(raw.secret_key_reference as int64),
bronze.external_crm_id  =	raw.external_crm_id  	

WHEN NOT MATCHED THEN INSERT (
id    	,
uuid 	,
name  	,
email  	,
access_key  	,
secret_key  	,
degree  	,
created_at  	,
updated_at  	,
created_at_date,
access_key_reference   	,
secret_key_reference   	,
external_crm_id  	,
dt_carga_trusted 	
)
VALUES (
raw.id   	,
raw.uuid 	,
raw.name  	,
raw.email  	,
raw.access_key  	,
raw.secret_key  	,
raw.degree  	,
raw.created_at  	,
raw.updated_at  	,
raw.created_at_date,
raw.access_key_reference   	,
raw.secret_key_reference   	,
raw.external_crm_id  	,
CURRENT_DATETIME('-03:00')
);

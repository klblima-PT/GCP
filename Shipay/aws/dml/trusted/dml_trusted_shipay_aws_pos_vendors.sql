
-- ** orders  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay_aws.pos_vendors` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
 safe_cast(id as int64) as id  			   
,uuid 			
,name 			
,cnpj 			
,email 			
,safe_cast(active as bool)  as active  			
 ,safe_cast(created_at as timestamp) as created_at   
	,safe_cast(updated_at as timestamp) as updated_at  
	,created_at_date	
,degree 			
,external_crm_id 
,dt_carga_raw ,
     
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY degree DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay_aws.pos_vendors`
    WHERE created_at_date = current_date()
    AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR)
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id  			     = raw.id  					,
bronze.uuid 			 = raw.uuid 				,
bronze.name 			 = raw.name 				,
bronze.cnpj 			 = raw.cnpj 				,
bronze.email 			 = raw.email 				,
bronze.active 			 = safe_cast(raw.active as bool)  				,
bronze.created_at  		 = safe_cast(raw.created_at as timestamp)  			,
bronze.updated_at  		 = safe_cast(raw.updated_at as timestamp)   			,
bronze.created_at_date  = raw.created_at_date  ,
bronze.degree 			 = raw.degree 				,
bronze.external_crm_id   = raw.external_crm_id	

WHEN NOT MATCHED THEN INSERT (
id  			 ,  
uuid 			,
name 			,
cnpj 			,
email 			,
active  		,	
created_at  ,		
updated_at  ,		
created_at_date  ,	
degree 			,
external_crm_id ,
dt_carga_trusted 
	

)
VALUES (
raw.id  					,
raw.uuid 				,
raw.name 				,
raw.cnpj 				,
raw.email 				,
raw.active  				,
raw.created_at  			,
raw.updated_at  			,
raw.created_at_date,
raw.degree 				,
raw.external_crm_id	,
CURRENT_DATETIME('-03:00')
);

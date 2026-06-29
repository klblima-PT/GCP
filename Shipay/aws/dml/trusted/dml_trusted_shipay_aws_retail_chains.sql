
-- ** retail_chains  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay_aws.retail_chains` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
safe_cast(id as int64) as id,               
name,             
uuid ,            
email ,           
degree ,          
  safe_cast(created_at as timestamp) as created_at,      
safe_cast(updated_at as timestamp) as updated_at , 
created_at_date,     
external_crm_id,  
dt_carga_raw    , 

     
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY degree DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay_aws.retail_chains`
   WHERE created_at_date = current_date()
     AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR)
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id               = raw.id         ,
bronze.name             = raw.name        ,     
bronze.uuid             = raw.uuid         ,    
bronze.email            = raw.email         ,   
bronze.degree           = raw.degree         ,  

bronze.created_at       = safe_cast(raw.created_at as timestamp) ,
bronze.updated_at       = safe_cast(raw.updated_at as timestamp)       ,
bronze.created_at_date       = raw.created_at_date     , 
bronze.external_crm_id  = raw.external_crm_id  

WHEN NOT MATCHED THEN INSERT (
 id             
,name           
,uuid           
,email          
,degree         
,created_at     
,updated_at   
,created_at_date
,external_crm_id
,dt_carga_trusted   

	

)
VALUES (
 raw.id             
,raw.name           
,raw.uuid           
,raw.email          
,raw.degree         
,raw.created_at     
,raw.updated_at   
,raw.created_at_date  
,raw.external_crm_id
,CURRENT_DATETIME('-03:00')
);


-- ** retail_chains  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay.pos_products` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
safe_cast(id as int64) as id  ,
uuid  ,
name  ,
email  ,
safe_cast(pos_vendor_id as int64) as pos_vendor_id  ,
safe_cast(active as bool) as active  ,
safe_cast(created_at as timestamp) as created_at,
safe_cast(updated_at as timestamp) as updated_at   ,
created_at_date,
degree   ,
safe_cast(fake_register as bool) as fake_register  ,
safe_cast(notify as bool)  as notify  ,
logo  ,
external_crm_id  ,   
dt_carga_raw,
     
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY degree DESC) AS rnk 
     
	 FROM
       `production-347022.raw_shipay.pos_products`
 WHERE created_at_date = current_date()
    AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR) 
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id  = raw.id  ,
bronze.uuid  = raw.uuid  ,
bronze.name  = raw.name  ,
bronze.email  = raw.email  ,
bronze.pos_vendor_id  = raw.pos_vendor_id  ,
bronze.active  = raw.active  ,
bronze.created_at  = raw.created_at  ,
bronze.updated_at   = raw.updated_at   ,
bronze.created_at_date  = raw.created_at_date  ,
bronze.degree   = raw.degree   ,
bronze.fake_register  = raw.fake_register  ,
bronze.notify  = raw.notify  ,
bronze.logo  = raw.logo  ,
bronze.external_crm_id  = raw.external_crm_id  

WHEN NOT MATCHED THEN INSERT (
id  ,
uuid  ,
name  ,
email  ,
pos_vendor_id  ,
active  ,
created_at  ,
updated_at   ,
created_at_date,
degree   ,
fake_register  ,
notify  ,
logo  ,
external_crm_id  ,
dt_carga_trusted	

)
VALUES (
raw.id  ,
raw.uuid  ,
raw.name  ,
raw.email  ,
raw.pos_vendor_id  ,
raw.active  ,
raw.created_at  ,
raw.updated_at   ,
raw.created_at_date,
raw.degree   ,
raw.fake_register  ,
raw.notify  ,
raw.logo  ,
raw.external_crm_id  ,
CURRENT_DATETIME('-03:00')
);

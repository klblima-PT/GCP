
-- ** store  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `production-347022.trusted_shipay_aws.stores` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
safe_cast(id as int64) as id ,
safe_cast(created_at as timestamp) as created_at  ,
safe_cast(updated_at as timestamp) as updated_at   ,
created_at_date,
name  ,
uuid  ,
safe_cast(active as bool) as active  ,
zip_code  ,
street_name  ,
street_number  ,
city_name  ,
state_name  ,
safe_cast(latitude as float64) as latitude  ,
safe_cast(longitude as float64) as longitude  ,
reference  ,
meta_data  ,
safe_cast(customer_id as int64) as customer_id  ,
cnpj_cpf  ,
safe_cast(headquarter as bool) as headquarter  ,
degree  ,
person_type  ,
neighborhood  ,
  safe_cast(zendesk_deal_id as int64) as zendesk_deal_id ,
dt_carga_raw,


     
      ROW_NUMBER() OVER(PARTITION BY id ORDER BY customer_id,degree,name DESC) AS rnk 
     
	 FROM
        `production-347022.raw_shipay_aws.stores`
   WHERE created_at_date = current_date()
       AND SAFE_CAST(updated_at AS DATETIME) BETWEEN DATETIME_SUB(DATETIME(current_datetime()), INTERVAL ${horas_intervalo} HOUR) 
    AND DATETIME_SUB(DATETIME(current_datetime()), INTERVAL 0 HOUR)
    ) 
  WHERE
    rnk = 1
) AS raw

ON  bronze.id	= raw.id

WHEN MATCHED THEN UPDATE SET
bronze.id 					=  raw.id 				,
bronze.created_at           =  raw.created_at      ,
bronze.updated_at           =  raw.updated_at      ,
bronze.created_at_date           =  raw.created_at_date      ,
bronze.name                 =  raw.name            ,
bronze.uuid                 =  raw.uuid            ,
bronze.active               =  raw.active          ,
bronze.zip_code             =  raw.zip_code        ,
bronze.street_name          =  raw.street_name     ,
bronze.street_number        =  raw.street_number   ,
bronze.city_name            =  raw.city_name       ,
bronze.state_name           =  raw.state_name      ,
bronze.latitude             =  raw.latitude        ,
bronze.longitude            =  raw.longitude       ,
bronze.reference            =  raw.reference       ,
bronze.meta_data            =  raw.meta_data       ,
bronze.customer_id          =  raw.customer_id     ,
bronze.cnpj_cpf             =  raw.cnpj_cpf        ,
bronze.headquarter          =  raw.headquarter     ,
bronze.degree               =  raw.degree          ,
bronze.person_type          =  raw.person_type     ,
bronze.neighborhood         =  raw.neighborhood    ,
bronze.zendesk_deal_id      =  raw.zendesk_deal_id 

   


WHEN NOT MATCHED THEN INSERT (
id ,
created_at  ,
updated_at   ,
created_at_date,
name  ,
uuid  ,
active  ,
zip_code  ,
street_name  ,
street_number  ,
city_name  ,
state_name  ,
latitude  ,
longitude  ,
reference  ,
meta_data  ,
customer_id  ,
cnpj_cpf  ,
headquarter  ,
degree  ,
person_type  ,
neighborhood  ,
zendesk_deal_id  ,
dt_carga_trusted 

)
VALUES (
raw.id 				,
raw.created_at      ,
raw.updated_at      ,
raw.created_at_date,
raw.name            ,
raw.uuid            ,
raw.active          ,
raw.zip_code        ,
raw.street_name     ,
raw.street_number   ,
raw.city_name       ,
raw.state_name      ,
raw.latitude        ,
raw.longitude       ,
raw.reference       ,
raw.meta_data       ,
raw.customer_id     ,
raw.cnpj_cpf        ,
raw.headquarter     ,
raw.degree          ,
raw.person_type     ,
raw.neighborhood    ,
raw.zendesk_deal_id ,
CURRENT_DATETIME('-03:00')
);

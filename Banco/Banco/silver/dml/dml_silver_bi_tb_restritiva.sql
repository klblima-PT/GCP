
-- ** tb_restritiva  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.silver_bi.tb_restritiva` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
cd_lv,
cd_listado		,
cd_tp_lista		,
de_listado		,
fl_alteravel   	,
dt_desativacao	,
de_complemento	,
cpf_cnpj		,
dt_nasc_fundacao ,

      
      ROW_NUMBER() OVER(PARTITION BY cd_listado ORDER BY dt_nasc_fundacao  DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.bronze_bi.tbl_restritiva`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.cd_listado = raw.cd_listado  

WHEN MATCHED THEN UPDATE SET
bronze.cd_lv = raw.cd_lv,
bronze.cd_listado          = raw.cd_listado ,
bronze.cd_tp_lista	= raw.cd_tp_lista,
bronze.de_listado		= raw.de_listado,
bronze.fl_alteravel   	= raw.fl_alteravel,
bronze.dt_desativacao	= raw.dt_desativacao,
bronze.de_complemento	= raw.de_complemento,
bronze.cpf_cnpj		= raw.cpf_cnpj,
bronze.dt_nasc_fundacao = raw.dt_nasc_fundacao

WHEN NOT MATCHED THEN INSERT (
  cd_lv,
cd_listado		,
cd_tp_lista		,
de_listado		,
fl_alteravel   	,
dt_desativacao	,
de_complemento	,
cpf_cnpj		,
dt_nasc_fundacao ,
  dt_carga_bronze
)
VALUES (
  raw.cd_lv,
raw.cd_listado		,
raw.cd_tp_lista		,
raw.de_listado		,
raw.fl_alteravel   	,
raw.dt_desativacao	,
raw.de_complemento	,
raw.cpf_cnpj		,
raw.dt_nasc_fundacao ,
CURRENT_DATETIME('-03:00')
);

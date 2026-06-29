
-- ** tbl_origem  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.bronze_bi_rendimento.tbl_origem`
(
  tbl_bigquery STRING,
  tbl_dm STRING,
  tbl_origem STRING,
  servidor_origem STRING,
  dt_carga_bronze DATETIME,

  PRIMARY KEY
    (tbl_origem) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY tbl_origem
    

OPTIONS (
  DESCRIPTION = 'Table TBL_Origem T clustered by tbl_origem'
); 

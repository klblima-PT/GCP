
-- ** tb_restritiva  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.silver_bi.tb_restritiva`
(
 cd_lv		STRING,
 cd_listado		STRING,
cd_tp_lista		STRING,
de_listado		STRING,
fl_alteravel   	STRING,
dt_desativacao	STRING,
de_complemento	STRING,
cpf_cnpj		STRING,
dt_nasc_fundacao STRING,
dt_carga_bronze DATETIME,
  PRIMARY KEY
    (cd_listado) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY dt_nasc_fundacao
    

OPTIONS (
  DESCRIPTION = 'Table tb_restritiva  clustered by dt_nasc_fundacao'
); 

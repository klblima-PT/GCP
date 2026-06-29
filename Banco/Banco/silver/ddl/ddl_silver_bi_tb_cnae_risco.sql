
-- ** tb_cnae_risco  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.silver_bi.tb_cnae_risco`
(
 Documento STRING,	
CodCnae STRING,	
EscalaRiscoId INT64,	
Escala_Risco STRING,	
Subclasse STRING,	
Cnae_Desc STRING,	
Descricao STRING,	
Desc_Escala STRING,
dt_carga_bronze DATETIME,
  PRIMARY KEY
    (Documento) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY Documento
    

OPTIONS (
  DESCRIPTION = 'Table tb_cnae_risco  clustered by Documento'
); 

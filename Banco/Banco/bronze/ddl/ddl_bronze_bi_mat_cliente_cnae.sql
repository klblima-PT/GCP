
-- ** mat_clientecnae  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi_rendimento.mat_clientecnae`
(
 documento STRING,
 sessao STRING,
 sessao_desc STRING,
 codcnae STRING, 
 cnae_desc STRING,
 tipocod STRING,
 dt_carga_bronze DATETIME,
  PRIMARY KEY
    (Documento) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY CodCnae
    

OPTIONS (
  DESCRIPTION = 'Table mat_clientecnae  clustered by codcnae'
); 

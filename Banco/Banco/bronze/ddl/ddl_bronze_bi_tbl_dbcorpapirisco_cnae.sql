
-- ** tbl_dbcorpapirisco_cnae  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi_rendimento.tbl_dbcorpapirisco_cnae`
(
 sk_dbcorpapirisco_cnae INT64,
  cnaeid INT64,
  usuarioinclusaoid INT64,
  usuarioalteracaoid INT64,
  escalariscoid INT64,
  datahorainclusao DATETIME,
  datahoraalteracao DATETIME,
  status BOOL,
  secao STRING,
  divisao STRING,
  grupo STRING,
  classe STRING,
  subclasse STRING,
  descricao STRING,
  datainiciovigenciactrl DATETIME,
  datafimvigenciactrl DATETIME,
  ativoctrl BOOL,
 dt_carga_bronze DATETIME,
  PRIMARY KEY
    (CnaeId) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY EscalaRiscoId
    

OPTIONS (
  DESCRIPTION = 'Table tbl_dbcorpapirisco_cnae clustered by EscalaRiscoId'
); 

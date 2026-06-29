
-- ** tbl_dbcorpapirisco_escalarisco  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi.tbl_dbcorpapirisco_escalarisco`
(
sk_dbcorpapirisco_escalarisco INT64,
  escalariscoid INT64,
  valor INT64,
  usuarioinclusaoid INT64,
  usuarioalteracaoid INT64,
  datahorainclusao DATETIME,
  datahoraalteracao DATETIME,
  status BOOL,
  descricao STRING,
  datainiciovigenciactrl DATETIME,
  datafimvigenciactrl DATETIME,
  ativoctrl BOOL,
 dt_carga_bronze DATETIME,
  PRIMARY KEY
    (EscalaRiscoId) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY DataHoraAlteracao
    

OPTIONS (
  DESCRIPTION = 'Table tbl_dbcorpapirisco_escalarisco clustered by DataHoraAlteracao'
); 


-- ** tbl_conta_corrente_movto  **
-- DEVELOPED BY Kleber  CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS   `corporativo-poc.bronze_bi.bi_contacorrente_tbl_contacorrentemovto`
(
  codcoligada STRING,
  codagencia STRING,
  nroconta STRING,
  datamovto DATETIME,
  nromovimento INT64,
  nrodocto STRING,
  natureza STRING,
  codposto STRING,
  codgerente STRING,
  sisorigem STRING,
  datasist DATETIME,
  codhist STRING,
  valor FLOAT64,
  bcoorigem STRING,
  ageorigem STRING,
  sitcontabil STRING,
  origem STRING,
  status STRING,
  estornado STRING,
  dataestorno DATETIME,
  nroarquivo INT64,
  seqarquivo STRING,
  nroarqctb INT64,
  codmodelo STRING,
  tarifado STRING,
  debitado STRING,
  entradaage STRING,
  nroorigem INT64,
  valorcpmf FLOAT64,
  codtributacao STRING,
  codisencao STRING,
  dataexclusao DATETIME,
  codusuario STRING,
  dataatu DATETIME,
  dtadebcpmf DATETIME,
  agedestino STRING,
  ctbinterage STRING,
  nroestorno INT64,
  chequesustado STRING,
  nromovimentoeb INT64,
  nsu_sgc INT64,
  codbcoint STRING,
  nrolote INT64,
  datainsercaoctrl DATETIME,
  datainicioctrl DATETIME,
  datafimctrl DATETIME,
  dataparticaoctrl DATE,
  dt_carga_bronze DATETIME,

  PRIMARY KEY
    (codagencia, nroconta, nromovimento) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY datamovto
    

OPTIONS (
  DESCRIPTION = 'Table BI_CONTACORRENTE_TBL_ContaCorrenteMovto clustered by datamovto'
); 

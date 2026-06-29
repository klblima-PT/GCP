
-- ** bi_pix_tbl_pix_statusanotacaocredito  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi.bi_pix_tbl_pix_statusanotacaocredito`
(
   sk_pix_statusanotacaocredito INT64,
  data_hora_processamento DATETIME,
  data_hora_registro DATETIME,
  id INT64,
  nro_movimento INT64,
  id_bacen_psp_final INT64,
  end_to_end STRING,
  info_erros STRING,
  status_anotacao_credito STRING,
  campo_extra STRING,
  datainsercaoctrl DATETIME,
  datainicioctrl DATE,
  datafimctrl DATE,
  dataparticaoctrl DATE,
  dataatualizacaoctrl DATETIME,
  dt_carga_bronze 				DATETIME,

  PRIMARY KEY
    (id, data_hora_registro) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY data_hora_registro
    

OPTIONS (
  DESCRIPTION = 'Table bi_pix_tbl_pix_statusanotacaocredito clustered by data_hora_registro'
); 

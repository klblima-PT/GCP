
-- ** tbl_pix_status_anotacao_credito  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi.bi_pix_tbl_pix_anotacaocredito`
(
  sk_pix_anotacaocredito INT64,
  data_hora_registro DATETIME,
  data_hora_processamento DATETIME,
  valor NUMERIC,
  id_idempotente_ebank STRING,
  id_bacen_psp INT64,
  nro_movimento INT64,
  id_bacen_psp_final INT64,
  id_anotacao_credito INT64,
  end_to_end STRING,
  cod_ispb STRING,
  cod_coligada STRING,
  cod_agencia STRING,
  nro_conta STRING,
  tipo_conta STRING,
  referencia_interna STRING,
  chave_enderecamento STRING,
  campo_livre STRING,
  origem_movimento STRING,
  cod_devolucao_pacs004 STRING,
  info_devolucao_pacs004 STRING,
  status_anotacao_credito STRING,
  cod_usuario STRING,
  info_erros STRING,
  nome STRING,
  nome_contra_parte STRING,
  cod_operacao STRING,
  cpf_cnpj STRING,
  cod_ispb_contra_parte STRING,
  cod_agencia_contra_parte STRING,
  nro_conta_contra_parte STRING,
  tipo_conta_contra_parte STRING,
  cpf_cnpj_contra_parte STRING,
  datainsercaoctrl DATETIME,
  datainicioctrl DATE,
  datafimctrl DATE,
  dataparticaoctrl DATE,
  dataatualizacaoctrl DATETIME,
  dt_carga_bronze DATETIME,

  PRIMARY KEY
    (id_anotacao_credito, data_hora_registro) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY data_hora_processamento
    

OPTIONS (
  DESCRIPTION = 'Table bi_pix_tbl_pix_anotacaocredito clustered by data_hora_processamento'
); 

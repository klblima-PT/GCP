
-- ** tbl_pix_movimentos_externos  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi.bi_pix_tbl_pix_movimentosexternos`
(
  sk_pix_movimentosexternos INT64,
  data_hora_registro DATETIME,
  data_hora_processamento DATETIME,
  valor NUMERIC,
  id_idempotente_ebank STRING,
  id INT64,
  id_ordem_pagamento INT64,
  nro_movimento INT64,
  id_bacen_psp_final INT64,
  id_bloqueio_ordem_pagamento INT64,
  id_msg STRING,
  cod_msg STRING,
  mensagem STRING,
  cod_usuario STRING,
  status_ordem_pagamento STRING,
  informacao_adicional STRING,
  info_devolucao_pacs004 STRING,
  canal_entrada STRING,
  id_devolucao STRING,
  cod_operacao STRING,
  campo_livre STRING,
  origem_movimento STRING,
  chave_enderecamento STRING,
  referencia_interna STRING,
  cod_devolucao_pacs004 STRING,
  tipo_conta_contra_parte STRING,
  cpf_cnpj_contra_parte STRING,
  status_bloqueio STRING,
  info_erros STRING,
  nome_contra_parte STRING,
  nome STRING,
  nro_conta STRING,
  tipo_conta STRING,
  cpf_cnpj STRING,
  cod_ispb_contra_parte STRING,
  cod_agencia_contra_parte STRING,
  nro_conta_contra_parte STRING,
  id_idempotente STRING,
  end_to_end STRING,
  chave_bloqueio STRING,
  cod_ispb STRING,
  cod_coligada STRING,
  cod_agencia STRING,
  datainsercaoctrl DATETIME,
  datainicioctrl DATE,
  datafimctrl DATE,
  dataparticaoctrl DATE,
  dataatualizacaoctrl DATETIME,

  -- COLUMNS CREATED TO BIGQUERY TREATMENT
  --dt_carga_raw DATETIME,
  dt_carga_bronze DATETIME,

  PRIMARY KEY
    (end_to_end,cod_ispb) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY data_hora_processamento
    

OPTIONS (
  DESCRIPTION = 'Table BI_PIX_TBL_Pix_MovimentosExternos clustered by data_hora_processamento'
); 


-- ** atend_audit_prevent  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

CREATE TABLE IF NOT EXISTS analytics-dev-415012.bronze_oracle_sabius.atend_audit_prevent (
  num_atend INT64,
  num_atend_original INT64,
  unimed_atendimento INT64,
  unimed_cart_benef INT64,
  cod_cart_benef INT64,
  sexo STRING,
  data_nasc DATETIME,
  rg INT64,
  verif_biometria STRING,
  cod_mot_liberacao_biom INT64,
  versao INT64,
  tipo_solicitacao STRING,
  nome STRING,
  biometria_ok STRING,
  cod_beneficiario INT64,
  cod_unimed INT64,
  cod_empresa INT64,
  cod_familia INT64,
  cod_contrato INT64,
  dv_cart_benef STRING,
  prioridade INT64,
  opme STRING,
  dispara_email_opme INT64,
  carregado_opme INT64,
  num_protocolo_ans INT64,
  num_protocolo_ori INT64,
  benef_atend_presencial STRING,
  data_insercao_reg DATETIME,
  usuario_insercao_reg STRING,
  terceiro STRING,
  nome_completo_terceiro STRING,
  sem_email STRING,

  -- COLUMNS CREATED TO BIGQUERY TREATMENT
  dt_carga_raw DATETIME,
  dt_carga_bronze DATETIME,

  PRIMARY KEY
    (num_atend) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY
    num_atend

OPTIONS (
  DESCRIPTION = 'Table ATEND_AUDIT_PREVENT clustered by num_atend'
); 

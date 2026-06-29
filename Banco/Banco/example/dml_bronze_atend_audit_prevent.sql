
-- ** atend_audit_prevent  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `analytics-dev-415012.bronze_oracle_sabius.atend_audit_prevent` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
      SAFE_CAST(num_atend AS INT64) AS num_atend,
      SAFE_CAST(num_atend_original AS INT64) AS num_atend_original,
      SAFE_CAST(unimed_atendimento AS INT64) AS unimed_atendimento,
      SAFE_CAST(unimed_cart_benef AS INT64) AS unimed_cart_benef,
      SAFE_CAST(cod_cart_benef AS INT64) AS cod_cart_benef,
      SAFE_CAST(sexo AS STRING) AS sexo,
      SAFE_CAST(data_nasc AS DATE) AS data_nasc,
      SAFE_CAST(rg AS INT64) AS rg,
      SAFE_CAST(verif_biometria AS STRING) AS verif_biometria,
      SAFE_CAST(cod_mot_liberacao_biom AS INT64) AS cod_mot_liberacao_biom,
      SAFE_CAST(versao AS INT64) AS versao,
      SAFE_CAST(tipo_solicitacao AS STRING) AS tipo_solicitacao,
      SAFE_CAST(nome AS STRING) AS nome,
      SAFE_CAST(biometria_ok AS STRING) AS biometria_ok,
      SAFE_CAST(cod_beneficiario AS INT64) AS cod_beneficiario,
      SAFE_CAST(cod_unimed AS INT64) AS cod_unimed,
      SAFE_CAST(cod_empresa AS INT64) AS cod_empresa,
      SAFE_CAST(cod_familia AS INT64) AS cod_familia,
      SAFE_CAST(cod_contrato AS INT64) AS cod_contrato,
      SAFE_CAST(dv_cart_benef AS STRING) AS dv_cart_benef,
      SAFE_CAST(prioridade AS INT64) AS prioridade,
      SAFE_CAST(opme AS STRING) AS opme,
      SAFE_CAST(dispara_email_opme AS INT64) AS dispara_email_opme,
      SAFE_CAST(carregado_opme AS INT64) AS carregado_opme,
      SAFE_CAST(num_protocolo_ans AS INT64) AS num_protocolo_ans,
      SAFE_CAST(num_protocolo_ori AS INT64) AS num_protocolo_ori,
      SAFE_CAST(benef_atend_presencial AS STRING) AS benef_atend_presencial,
      SAFE_CAST(data_insercao_reg AS DATE) AS data_insercao_reg,
      SAFE_CAST(usuario_insercao_reg AS STRING) AS usuario_insercao_reg,
      SAFE_CAST(terceiro AS STRING) AS terceiro,
      SAFE_CAST(nome_completo_terceiro AS STRING) AS nome_completo_terceiro,
      SAFE_CAST(sem_email AS STRING) AS sem_email,
      SAFE_CAST(dt_carga_raw AS DATETIME) AS dt_carga_raw,
      
      ROW_NUMBER() OVER(PARTITION BY num_atend ORDER BY _PARTITIONDATE DESC) AS rnk 
     
	 FROM
        `analytics-dev-415012.raw_oracle_sabius.atend_audit_prevent`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.num_atend = raw.num_atend  

WHEN MATCHED THEN UPDATE SET
  bronze.num_atend = raw.num_atend,
  bronze.num_atend_original = raw.num_atend_original,
  bronze.unimed_atendimento = raw.unimed_atendimento,
  bronze.unimed_cart_benef = raw.unimed_cart_benef,
  bronze.cod_cart_benef = raw.cod_cart_benef,
  bronze.sexo = raw.sexo,
  bronze.data_nasc = raw.data_nasc,
  bronze.rg = raw.rg,
  bronze.verif_biometria = raw.verif_biometria,
  bronze.cod_mot_liberacao_biom = raw.cod_mot_liberacao_biom,
  bronze.versao = raw.versao,
  bronze.tipo_solicitacao = raw.tipo_solicitacao,
  bronze.nome = raw.nome,
  bronze.biometria_ok = raw.biometria_ok,
  bronze.cod_beneficiario = raw.cod_beneficiario,
  bronze.cod_unimed = raw.cod_unimed,
  bronze.cod_empresa = raw.cod_empresa,
  bronze.cod_familia = raw.cod_familia,
  bronze.cod_contrato = raw.cod_contrato,
  bronze.dv_cart_benef = raw.dv_cart_benef,
  bronze.prioridade = raw.prioridade,
  bronze.opme = raw.opme,
  bronze.dispara_email_opme = raw.dispara_email_opme,
  bronze.carregado_opme = raw.carregado_opme,
  bronze.num_protocolo_ans = raw.num_protocolo_ans,
  bronze.num_protocolo_ori = raw.num_protocolo_ori,
  bronze.benef_atend_presencial = raw.benef_atend_presencial,
  bronze.data_insercao_reg = raw.data_insercao_reg,
  bronze.usuario_insercao_reg = raw.usuario_insercao_reg,
  bronze.terceiro = raw.terceiro,
  bronze.nome_completo_terceiro = raw.nome_completo_terceiro,
  bronze.sem_email = raw.sem_email

WHEN NOT MATCHED THEN INSERT (
  num_atend,
  num_atend_original,
  unimed_atendimento,
  unimed_cart_benef,
  cod_cart_benef,
  sexo,
  data_nasc,
  rg,
  verif_biometria,
  cod_mot_liberacao_biom,
  versao,
  tipo_solicitacao,
  nome,
  biometria_ok,
  cod_beneficiario,
  cod_unimed,
  cod_empresa,
  cod_familia,
  cod_contrato,
  dv_cart_benef,
  prioridade,
  opme,
  dispara_email_opme,
  carregado_opme,
  num_protocolo_ans,
  num_protocolo_ori,
  benef_atend_presencial,
  data_insercao_reg,
  usuario_insercao_reg,
  terceiro,
  nome_completo_terceiro,
  sem_email,
  dt_carga_raw,
  dt_carga_bronze
)
VALUES (
  raw.num_atend,
  raw.num_atend_original,
  raw.unimed_atendimento,
  raw.unimed_cart_benef,
  raw.cod_cart_benef,
  raw.sexo,
  raw.data_nasc,
  raw.rg,
  raw.verif_biometria,
  raw.cod_mot_liberacao_biom,
  raw.versao,
  raw.tipo_solicitacao,
  raw.nome,
  raw.biometria_ok,
  raw.cod_beneficiario,
  raw.cod_unimed,
  raw.cod_empresa,
  raw.cod_familia,
  raw.cod_contrato,
  raw.dv_cart_benef,
  raw.prioridade,
  raw.opme,
  raw.dispara_email_opme,
  raw.carregado_opme,
  raw.num_protocolo_ans,
  raw.num_protocolo_ori,
  raw.benef_atend_presencial,
  raw.data_insercao_reg,
  raw.usuario_insercao_reg,
  raw.terceiro,
  raw.nome_completo_terceiro,
  raw.sem_email,
  raw.dt_carga_raw,
  CURRENT_DATETIME('-03:00')
);

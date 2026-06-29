
-- ** tb_pix_enviados  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.silver_bi.tb_pix_enviados`
(
sk_pix_bloqueio_ordem_pagamento INT64,
campo_livre STRING,
canal_entrada STRING,
chave_bloqueio STRING,
chave_enderecamento STRING,
cod_agencia STRING,
cod_agencia_contra_parte STRING,
cod_coligada STRING,
cod_devolucao_pacs004 STRING,
cod_ispb STRING,
cod_ispb_contra_parte STRING,
cod_operacao STRING,
cod_usuario STRING,
cpf_cnpj STRING,
cpf_cnpj_contra_parte STRING,
cpf_cnpj_iniciador STRING,
data_hora_processamento_pix_enviado DATETIME,
data_hora_registro_pix_enviado DATETIME,
eh_agendado BOOL,
end_to_end_pix_enviado STRING,
end_to_end_original STRING,
finalidade_transacao STRING,
id_bacen_psp_final INT64,
id_bloqueio_ordem_pagamento INT64,
id_devolucao STRING,
id_idempotente_ebank STRING,
id_ordem_pagamento_pix_enviado INT64,
info_devolucao_pacs004 STRING,
info_erros STRING,
modalidade_agente STRING,
modelo_ctb STRING,
motivo_med STRING,
nome STRING,
nome_contra_parte STRING,
nro_conta STRING,
nro_conta_contra_parte STRING,
nro_movimento INT64,
origem_movimento STRING,
prestador_servico_saque STRING,
referencia_interna STRING,
status_bloqueio STRING,
tipo_conta STRING,
tipo_conta_contra_parte STRING,
uuid_bloqueio_devolucao_especial STRING,
uuid_solicitacao_devolucao_especial STRING,
valor NUMERIC,
valor_compra NUMERIC,
valor_saque NUMERIC,
valor_troco NUMERIC,
dataatualizacaoctrl_pix_enviado DATETIME,
datainicioctrl_pix_enviado DATE,
datainsercaoctrl_pix_enviado DATETIME,
dataparticaoctrl_pix_enviado DATE,
dt_carga_bronze_pix_enviado DATETIME,
sk_pix_status_ordem_pagamento INT64,
data_hora_processamento DATETIME,
data_hora_registro DATETIME,
id INT64,
id_ordem_pagamento INT64,
informacao_adicional STRING,
status_ordem_pagamento STRING,
dataatualizacaoctrl DATETIME,
datafimctrl DATE,
datainicioctrl DATE,
datainsercaoctrl DATETIME,
dataparticaoctrl DATE,
dt_carga_bronze DATETIME,
  PRIMARY KEY
    (id) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY data_hora_processamento_pix_enviado
    

OPTIONS (
  DESCRIPTION = 'Table tb_pix_enviados  clustered by dt_nasc_fundacao'
); 

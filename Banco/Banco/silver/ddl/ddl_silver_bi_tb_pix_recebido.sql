
-- ** tb_pix_recebido  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.silver_bi.tb_pix_recebido`
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
end_to_end_pix_recebido STRING,	
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
status_anotacao_credito_pix_recebido STRING,	
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
dt_carga_bronze_pix_recebido DATETIME,	
sk_pix_statusanotacaocredito INT64,	
end_to_end STRING,	
status_anotacao_credito STRING,
dt_carga_bronze DATETIME,
  PRIMARY KEY
    (end_to_end) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY data_hora_registro
    

OPTIONS (
  DESCRIPTION = 'Table tb_pix_recebido  clustered by dt_nasc_fundacao'
); 

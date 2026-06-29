
-- ** tbl_info_banc_clientes  **
-- DEVELOPED BY kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi.bi_infobank_tbl_infobanc_clientes`
(
  codcliente STRING,
  cgc_cpf STRING,
  sequencia STRING,
  nome STRING,
  tipopessoa STRING,
  codcategoria STRING,
  tipotributacao STRING,
  codatividade STRING,
  codgerente STRING,
  status STRING,
  datacadastro DATETIME,
  dataatualizacao DATETIME,
  ind_factoring STRING,
  clientehomebank STRING,
  ind_tributacpmf STRING,
  datavencimento DATETIME,
  nomeusuario STRING,
  numdocumento STRING,
  tipodocumento STRING,
  orgaoexpedidor STRING,
  uf_orgaoexpedidor STRING,
  datadocumento DATETIME,
  regimetributacao STRING,
  datarenovacao DATETIME,
  origemcadastro STRING,
  indinvestinstit STRING,
  indisentoiof STRING,
  codgerenteant STRING,
  codfirma STRING,
  codglobal STRING,
  indautbank STRING,
  codcoligada STRING,
  codagencia STRING,
  codccusto STRING,
  codclassif_gerencial STRING,
  mesclientedesde STRING,
  anoclientedesde STRING,
  obsclientedesde STRING,
  datadesativacao DATETIME,
  codarea STRING,
  codsetor_atividade STRING,
  cp_acc STRING,
  cp_sec STRING,
  intragrupo STRING,
  dataatualizacaogerente DATETIME,
  motivoalteracaogerente STRING,
  codclassif_administrativa STRING,
  clienteproblematico STRING,
  codmotivoproblematico STRING,
  cdc_cnpj_valido STRING,
  dataparticaoctrl DATE,
  dt_carga_bronze DATETIME,

  PRIMARY KEY   (cgc_cpf, codcliente) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY datacadastro
    

OPTIONS (
  DESCRIPTION = 'Table BI_INFOBANK_TBL_InfoBanc_Clientes clustered by codcliente'
); 


-- ** tb_conta_pessoa_movimento_pj  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.silver_bi.tb_conta_pessoa_movimento_pj`
(
 codagencia STRING,	
nroconta STRING,	
cpf STRING,	
databertura DATETIME,	
codcliente STRING,	
nome STRING,	
tipopessoa STRING,	
datamovto DATETIME,	
nromovimento INT64,	
natureza STRING,	
bcoorigem STRING,	
ageorigem STRING,	
origem STRING,	
tarifado STRING,	
debitado STRING,	
entradaage STRING,	
codCnae STRING,	
documento STRING,	
Escala_Risco STRING,	
escalaRiscoId INT64,	
subclasse STRING,	
cnae_Desc STRING,	
descricao STRING,	
desc_Escala STRING,	
valor FLOAT64,
dt_carga_bronze DATETIME,
  PRIMARY KEY
    (documento) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY documento
    

OPTIONS (
  DESCRIPTION = 'Table tb_conta_pessoa_movimento_pj  clustered by dt_nasc_fundacao'
); 

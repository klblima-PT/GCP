
-- ** tb_conta_pessoa_movimento_pf  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.silver_bi.tb_conta_pessoa_movimento_pf`
(
 produto STRING,	
persona STRING,	
codagencia STRING,	
nroconta STRING,	
cpf STRING,	
nome_persona STRING,	
nrconta STRING,	
datamovto DATETIME,	
nromovimento INT64,	
natureza STRING,	
bcoorigem STRING,	
ageorigem STRING,	
agedestino STRING,	
origem STRING,	
tarifado STRING,	
debitado STRING,	
entradaage STRING,	
estornado STRING,	
dataestorno DATETIME,	
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
    (cpf) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY cpf
    

OPTIONS (
  DESCRIPTION = 'Table tb_conta_pessoa_movimento_pf  clustered by cpf'
); 

-- ** mat_dashpixmovimentacao  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc-hvar.silver_bi.tb_pix_agrup_movimentacao` 
(
anomes				STRING,
data				DATE,
tipopessoa			STRING,
enviadosrecebidos	STRING,
statusmensagem		STRING,
diretoindireto		STRING,
mesmatitularidade	STRING,
tipochave			STRING,
participanteorigem	STRING,
participantedestino	STRING,
participante		STRING,
faixahorario		STRING,
faixahorariofiltro	STRING,
possuichave			STRING,
transfinterna		STRING,
devolucao			STRING,
dtfaixahorario		STRING,
sistema				STRING,
codgerente			STRING,
clienteespecifico	STRING,
relatoriocomerro	STRING,
tipomes				STRING,
situacaobackoffice	STRING,
iddocumento			INT64,
nometop				STRING,
qtde				INT64,
valor				NUMERIC,
qtdetop				INT64,
valortop			NUMERIC,
dt_carga_bronze DATETIME,

  PRIMARY KEY
    (data) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY data
    

OPTIONS (
  DESCRIPTION = 'Table mat_dashpixmovimentacao clustered by data'
); 
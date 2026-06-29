
-- ** tbl_conta_corrente_conta  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi_rendimento.bi_contacorrente_tbl_contacorrente_conta`
(
codcoligada	STRING,
codagencia	STRING,
nroconta	STRING,
dataatu	DATETIME,
codposto	STRING,
databertura	DATETIME,
codgerente	STRING,
especie	STRING,
codsituacao	STRING	,
status	STRING,
tipdepos	STRING,
sdodia0	FLOAT64,
sdodia1	FLOAT64,
sdobloq0	FLOAT64,
sdobloq1	FLOAT64	,
modalori		STRING,
dataultmov		DATETIME,
dataultpro		DATETIME,
dataultext		DATETIME,
seqextrato		INT64,
sdoextrato		FLOAT64,
perextrato		STRING,
dataultdeb		DATETIME,
extbloqueado	STRING,
talbloqueado	STRING,
tipotalao		STRING,
qtdfltalao		STRING,
estminimo		INT64,
solautomat		STRING,
nroultchq		INT64,
codcoligmov		STRING,
codagencmov		STRING,
nrocontamov		STRING,
ordemtransf		STRING,
transfjuros		STRING,
nromovimento	INT64,
nropendente		INT64,
nrofuturo		INT64,
Codtributacao	STRING,
codisencao		STRING,
retencaocpmf	STRING,
codagetroca		STRING,
ultimosaldo		FLOAT64,
dataultsaldo	DATETIME,
codusuario		STRING,
provcpmfant		FLOAT64,
provcpmfatu		FLOAT64,
devcpmfant		FLOAT64,
devcpmfatu		FLOAT64,
nrodiasadpexc	INT64,
nrodiasneg		INT64,
cgc_cpfendereco	STRING,
seqendereco		STRING,
codendereco		STRING,
envioextrato	STRING,
homebanking		STRING,
nrodiasmovhb	INT64,
valorbloq		FLOAT64,
sitcredito		STRING,
transfautoca	STRING,
enviotalao		STRING,
restricao		STRING,
sequencial		FLOAT64,
ultimosaldobloq	FLOAT64	,
  dt_carga_bronze DATETIME,
  PRIMARY KEY
    (codagencia, nroconta) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY databertura
    

OPTIONS (
  DESCRIPTION = 'Table BI_CONTACORRENTE_TBL_ContaCorrente_Conta clustered by databertura'
); 

-- ** mat_movimentacaodetalhe  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi_rendimento.mat_movimentacaodetalhe`
(
idrow						INT64,
anomes						STRING,
data						DATE,
horario						TIME,
documento					STRING,
nome						STRING,
tipopessoa					STRING,
tipobase					STRING,
enviadosrecebidos			STRING,
endtoend					STRING,
datahoraregistro			DATETIME,
codispborigem				STRING,
codcoligadaorigem			STRING,
codagenciaorigem			STRING,
nrocontaorigem				STRING,
tipocontaorigem				STRING,
documentoorigem				STRING,
nomeorigem					STRING,
codispbdestino				STRING,
codcoligadadestino			STRING,
codagenciadestino			STRING,
nrocontadestino				STRING,
tipocontadestino			STRING,
documentodestino			STRING,
nomedestino					STRING,
valor						NUMERIC,
origemmovimento				STRING,
chaveenderecamento			STRING,
canalentrada				STRING,
coddevolucaopacs004			STRING,
dataoperacaoretorno			DATETIME,
motivorejeicao				STRING,
usuariosistema				STRING,
statusmensagem				STRING,
diretoindireto				STRING,
tipopessoaorigem			STRING,
tipopessoadestino			STRING,
mesmatitularidade			STRING,
tipochave					STRING,
participanteorigem			STRING,
participantedestino			STRING,
participante				STRING,
codispb						STRING,
desctipocontaorigem			STRING,
desctipocontadestino		STRING,
faixahorario				STRING,
faixahorariofiltro			STRING,
possuichave					STRING,
transfinterna				STRING,
devolucao					STRING,
dtfaixahorario				STRING,
sistema						STRING,
codgerente					STRING,
uuid_documento				STRING,
iddocumento					INT64 ,
clienteespecifico			STRING,
relatoriocomerro			STRING,
faixahorariolimites			STRING,
tipomes						STRING,
situacaobackoffice			STRING,
campolivre					STRING,
dt_carga_bronze DATETIME,

  PRIMARY KEY
    (endtoend) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY DataHoraRegistro
    

OPTIONS (
  DESCRIPTION = 'Table mat_movimentacaodetalhe clustered by DataHoraRegistro'
); 

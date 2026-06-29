
-- ** tb_conta_pessoa_movimento_pj  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team
truncate table `corporativo-poc-hvar.silver_bi.tb_conta_pessoa_movimento_pj`;

INSERT INTO `corporativo-poc-hvar.silver_bi.tb_conta_pessoa_movimento_pj` 
(
codagencia ,	
nroconta ,	
cpf ,	
databertura ,	
codcliente ,	
nome ,	
tipopessoa ,	
datamovto ,	
nromovimento ,	
natureza ,	
bcoorigem ,	
ageorigem ,	
origem ,	
tarifado ,	
debitado ,	
entradaage ,	
codCnae ,	
documento ,	
Escala_Risco ,	
escalaRiscoId ,	
subclasse ,	
cnae_Desc ,	
descricao ,	
desc_Escala ,	
valor 
)
WITH conta_digital as (

select distinct 
codagencia, 
nroconta,
cgc_cpfendereco, 
databertura, 
codgerente, 
codsituacao, 
restricao, 
dt_carga_bronze 
from `corporativo-poc-hvar.bronze_bi.bi_contacorrente_tbl_contacorrente_conta`
), 


movimentacao as (

select distinct 
codagencia, 
nroconta, 
datamovto, 
nromovimento, 
natureza,
bcoorigem, 
ageorigem, 
origem, 
valor,
tarifado,
debitado, 
entradaage, 
dt_carga_bronze 
from `corporativo-poc-hvar.bronze_bi.bi_contacorrente_tbl_contacorrentemovto` 
where origem = 'GI'
),

persona_pj as (

select distinct 
codcliente, 
cgc_cpf , 
nome, 
tipopessoa, 
codgerente,
numdocumento,
tipodocumento, 
orgaoexpedidor,
uf_orgaoexpedidor, 
dt_carga_bronze 
from `corporativo-poc-hvar.bronze_bi.bi_infobank_tbl_infobanc_clientes`

), 

cnae_risco as (
Select distinct  
CodCnae,
Documento,
EscalaRiscoId,
Escala_Risco,
Subclasse,
Cnae_Desc,
Descricao,
Desc_Escala 
from `corporativo-poc-hvar.silver_bi.vw_cnae_risco` 
)

/* Relacionamento dos dados */

select distinct a.codagencia, 
a.nroconta,
a.cgc_cpfendereco as cpf,  
a.databertura, 
b.codcliente, 
b.nome , 
b.tipopessoa, 
d.datamovto, 
d.nromovimento, 
d.natureza,
d.bcoorigem, 
d.ageorigem, 
d.origem, 
d.tarifado,
d.debitado, 
d.entradaage ,
e.codCnae,
e.documento,
e.Escala_Risco,
e.escalaRiscoId,
e.subclasse,
e.cnae_Desc,
e.descricao,
e.desc_Escala,  
d.valor 

from conta_digital a

inner join persona_pj b on a.cgc_cpfendereco =  b.cgc_cpf
inner join movimentacao d on a.codagencia = d.codagencia and  a.nroconta = d.nroconta
left join cnae_risco e on e.documento = cgc_cpfendereco;
--where cgc_cpfendereco = '68900810000138'
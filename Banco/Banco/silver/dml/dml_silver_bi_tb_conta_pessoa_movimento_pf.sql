
-- ** tb_conta_pessoa_movimento_pf  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team
truncate table `corporativo-poc-hvar.silver_bi.tb_conta_pessoa_movimento_pf`;

INSERT INTO `corporativo-poc-hvar.silver_bi.tb_conta_pessoa_movimento_pf` 
(
  produto ,	
persona ,	
codagencia ,	
nroconta ,	
cpf ,	
nome_persona ,	
nrconta ,	
datamovto ,	
nromovimento ,	
natureza ,	
bcoorigem ,	
ageorigem ,	
agedestino ,	
origem ,	
tarifado ,	
debitado ,	
entradaage ,	
estornado ,	
dataestorno ,	
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
estornado,
dataestorno,
agedestino, 
dt_carga_bronze 
from `corporativo-poc-hvar.bronze_bi.bi_contacorrente_tbl_contacorrentemovto` 
where origem = 'GI'  /* GI  = PIX */
),


persona_pf as (

select distinct 
cgc_cpf,
nome, 
nomefantasia, 
tipopessoa,
status,
numdocumento, 
tipodocumento, 
orgaoexpedidor,
dt_carga_bronze  
from `corporativo-poc-hvar.bronze_bi.bi_infobank_tbl_infobanc_pessoas` 
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

select distinct 
'PIX' AS produto,
'PF' AS persona,
a.codagencia, 
a.nroconta,
a.cgc_cpfendereco as cpf,  
c.nome as nome_persona,
d.nroconta as nrconta, 
d.datamovto, 
d.nromovimento, 
d.natureza,
d.bcoorigem, 
d.ageorigem, 
d.agedestino, 
d.origem, 
d.tarifado,
d.debitado, 
d.entradaage ,
d.estornado,
d.dataestorno,
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

inner join persona_pf c on a.cgc_cpfendereco = c.cgc_cpf 
inner join movimentacao d on a.codagencia = d.codagencia and  a.nroconta = d.nroconta
left join  cnae_risco e on e.documento = cgc_cpfendereco;

--where cgc_cpfendereco = '68900810000138'
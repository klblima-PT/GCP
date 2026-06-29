
create or replace view corporativo-poc-hvar.gold_bi.vw_pld_op_lista_restitiva as 
with detalhe as (
select 
 documento
,anomes
,enviadosrecebidos as tipo_movimentacao
,nrocontaorigem
,nomeorigem
,nrocontadestino
,nomedestino
FROM
  `corporativo-poc-hvar.bronze_bi.mat_movimentacaodetalhe`  
  group by 
   documento
  ,anomes
  ,enviadosrecebidos
 , nrocontaorigem
,nomeorigem
,nrocontadestino
,nomedestino

), 
restritiva as  (
SELECT * FROM `corporativo-poc-hvar.bronze_bi.tbl_restritiva` 
)



select 
 a.documento
,a.anomes
,a.tipo_movimentacao
,a.nrocontaorigem
,a.nomeorigem
,a.nrocontadestino
,a.nomedestino
,case when a.documento = b.cpf_cnpj then 'restrito' else 'nao_restrito' end lista_restritiva
from detalhe a
left join restritiva b
on a.documento = b.cpf_cnpj


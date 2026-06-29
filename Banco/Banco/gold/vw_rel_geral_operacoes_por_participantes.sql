
create or replace view corporativo-poc-hvar.gold_bi.vw_rel_geral_operacoes_por_participantes as 
with detalhe as (
select 
 documento
,anomes
,enviadosrecebidos as tipo_movimentacao
,participante
,sum(valor) as valor
,count(*) as qtd
FROM
  `corporativo-poc-hvar.bronze_bi.mat_movimentacaodetalhe`  
  group by 
   documento
  ,anomes
  ,enviadosrecebidos
  ,participante

)


select * from detalhe 





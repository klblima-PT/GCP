create or replace view corporativo-poc-hvar.gold_bi.vw_tb_pld_op_contratacoes as 

with detalhe as (
select 
 documento
,anomes
,enviadosrecebidos as tipo_movimentacao
FROM
  `corporativo-poc-hvar.bronze_bi.mat_movimentacaodetalhe`  
  group by 
   documento
  ,anomes
  ,enviadosrecebidos
),

enviados as (
select distinct
 documento
,anomes
,enviadosrecebidos
FROM
  `corporativo-poc-hvar.bronze_bi.mat_movimentacaodetalhe`   where enviadosrecebidos = 'Enviados'
  group by 
 documento
,anomes
,data
,enviadosrecebidos

)

select 
 a.documento
,a.anomes
,CASE
    WHEN a.documento = c.documento  AND a.anomes = c.anomes THEN 1 ELSE 0 END N_operacoes_enviadas_mesmo_valor_mesma_datas
from detalhe a
inner join enviados c
on a.documento = c.documento


create or replace view  corporativo-poc-hvar.gold_bi.vw_tb_rel_geral_top_beneficiarios as
/* PROJETO : BANCO  */
/* AUTOR: KLEBER - HVAR */
/* PROJETO:  GOLD_BANCO */
/* ULTIMA ATUALIZACAO : 18/07/2024 */

/* REBUILD */
/* - Visão contemplando a relatorio top 10 beneficiarios.*/

with cte as (
select 
 documentodestino
,anomes
--,enviadosrecebidos as tipo_movimentacao
,nomedestino
,sum(valor) as valor
,count(*) as qtd
,sum(valor)/count(*) as ticket_medio
FROM
  `corporativo-poc-hvar.silver_bi.tb_pix_movimentacao_detalhe` 
  group by 
   documentodestino
  ,anomes
  ,enviadosrecebidos
  ,nomedestino
), 
rank_ticket as (
SELECT 
documentodestino as documento
,anomes
--,tipo_movimentacao
,nomedestino as nome
, valor
,qtd
,ticket_medio
 , ROW_NUMBER() OVER (PARTITION BY anomes  ORDER BY cte.ticket_medio DESC
 ) AS finish_rank
FROM cte ),

rank_valor as (
SELECT 
documentodestino as documento
,anomes
--,tipo_movimentacao
,nomedestino as nome
, valor
,qtd
,ticket_medio
 , ROW_NUMBER() OVER (PARTITION BY anomes ORDER BY cte.valor DESC
 ) AS finish_rank
FROM cte ),

rank_qtd as (
SELECT 
documentodestino as documento
,anomes
--,tipo_movimentacao
,nomedestino as nome
, valor
,qtd
,ticket_medio
 , ROW_NUMBER() OVER (PARTITION BY anomes ORDER BY cte.qtd DESC
 ) AS finish_rank
FROM cte )


select 'ticket_medio' as tipo_freq, * from rank_ticket where finish_rank <= 10  
union all
select 'valor' as tipo_freq, * from rank_valor where finish_rank <= 10 
union all
select 'Qtd' as tipo_freq, * from rank_qtd where finish_rank <= 10

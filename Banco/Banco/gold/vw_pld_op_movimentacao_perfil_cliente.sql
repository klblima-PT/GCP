create or replace view corporativo-poc-hvar.gold_bi.vw_pld_op_movimentacao_perfil_cliente as 
select 
 documento
,anomes
,enviadosrecebidos as tipo_movimentacao
,tipopessoa
,sum(valor) as valor
,count(*) as qtd
,sum(valor)/count(*) as ticket_medio
FROM
  `corporativo-poc-hvar.bronze_bi.mat_movimentacaodetalhe`  
  group by 
   documento
  ,anomes
  ,enviadosrecebidos
  ,tipopessoa

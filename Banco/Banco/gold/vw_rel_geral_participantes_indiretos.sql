
create or replace view corporativo-poc-hvar.gold_bi.vw_rel_geral_participantes_indiretos as 

* PROJETO : BANCO */
/* AUTOR: KLEBER - HVAR */
/* PROJETO:  GOLD_BANCO */
/* ULTIMA ATUALIZACAO : 18/07/2024 */

/* REBUILD */
/* - Visão contemplando relatorios geral de indiretos.*/

select 
 documento
,anomes
,participante
,sum(CASE
    WHEN diretoindireto = 'Indiretos'  AND anomes = FORMAT_DATE("%Y-%m", CURRENT_DATE()) THEN 1
    ELSE 0 END) Participantes_Indiretos_PIX_Relacionamento_ativo
FROM
  `corporativo-poc-hvar.silver_bi.tb_pix_movimentacao_detalhe`  
  group by 
   documento
  ,anomes
  , participante





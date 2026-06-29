create or replace view corporativo-poc-hvar.gold_bi.tb_pld_op_frequencia_transacoes as

/* PROJETO : BANCO  */
/* AUTOR: KLEBER - HVAR */
/* PROJETO:  GOLD_BANCO_ */
/* ULTIMA ATUALIZACAO : 18/07/2024 */

/* REBUILD */
/* - Visão contemplando a frequência de transações (dias, mês, semestre ou ano);
.*/

with dados as ( 
SELECT documento, nome,enviadosrecebidos, datahoraregistro,anomes , data, horario,  FROM `corporativo-poc-hvar.silver_bi_.tb_pix_movimentacao_detalhe` where documento = '29383450000192' and enviadosrecebidos = 'Enviados'
),
dia as (
  select documento,nome,enviadosrecebidos,safe_cast(data as string) as dia, '1900-01-01'  as mes , '1900-01-01'  as ano,   count(*) as freq from dados where --documento = '29383450000192'and 
  enviadosrecebidos = 'Enviados'  group by  documento,nome,data, enviadosrecebidos
),
mes as (
select documento,nome,enviadosrecebidos, '1900-01-01' as dia , anomes as mes,'1900-01-01'  as ano, count(*) as freq  from dados where -- documento = '29383450000192' and 
enviadosrecebidos = 'Enviados' group by  documento,nome,anomes, enviadosrecebidos
),
ano as (
  select documento,nome,enviadosrecebidos ,'1900-01-01' as dia, '1900-01-01'  as mes , substr(anomes,1,4),count(*) as freq  from dados where --documento = '29383450000192'and 
  enviadosrecebidos = 'Enviados' group by  documento,nome,substr(anomes,1,4), enviadosrecebidos
)

select 
documento,nome, enviadosrecebidos 
, case when dia = '1900-01-01' then '' else dia end dia 
,case when mes = '1900-01-01' then '' else mes end mes
,case when ano = '1900-01-01' then '' else ano end  ano, freq 
from (
select * from  dia
union all
select * from  mes
union all
select * from  ano
)
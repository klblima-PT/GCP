
-- ** tb_pix_recebido  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

truncate table `corporativo-poc-hvar.silver_bi.tb_pix_recebido`;

INSERT INTO `corporativo-poc-hvar.silver_bi.tb_pix_recebido` 
(
 sk_pix_anotacaocredito 	
,data_hora_registro 	                         
,data_hora_processamento 					
,valor 	                        
,id_idempotente_ebank 	                
,id_bacen_psp 	                        
,nro_movimento 	                        
,id_bacen_psp_final 	                    
,id_anotacao_credito 	                    
,end_to_end_pix_recebido 	                
,cod_ispb 	                            
,cod_coligada 	                        
,cod_agencia 	                            
,nro_conta 	                            
,tipo_conta 	                            
,referencia_interna 	                    
,chave_enderecamento 	                    
,campo_livre 	                            
,origem_movimento 	                    
,cod_devolucao_pacs004 	                
,info_devolucao_pacs004 	                
,status_anotacao_credito_pix_recebido 	
,cod_usuario 	                            
,info_erros 	                            
,nome 	                                
,nome_contra_parte 	                    
,cod_operacao 	                        
,cpf_cnpj 	                            
,cod_ispb_contra_parte 	                
,cod_agencia_contra_parte 	            
,nro_conta_contra_parte 	                
,tipo_conta_contra_parte 	                
,cpf_cnpj_contra_parte 	                
,datainsercaoctrl 	                    
,datainicioctrl 	                        
,datafimctrl 	                            
,dataparticaoctrl 	                    
,dataatualizacaoctrl 	                    
,dt_carga_bronze_pix_recebido 	        
,sk_pix_statusanotacaocredito 	        
,end_to_end 	                            
,status_anotacao_credito                  
                                                  
)

With anotacao_credito as (
  SELECT distinct
  sk_pix_anotacaocredito,
  data_hora_registro,
  data_hora_processamento,
  valor,
  id_idempotente_ebank,
  id_bacen_psp,
  nro_movimento  ,
  id_bacen_psp_final ,
  id_anotacao_credito,
  end_to_end as end_to_end_pix_recebido,
  cod_ispb,
  cod_coligada,
  cod_agencia,
  nro_conta,
  tipo_conta,
  referencia_interna,
  chave_enderecamento,
  campo_livre,
  origem_movimento,
  cod_devolucao_pacs004,
  info_devolucao_pacs004,
  status_anotacao_credito as status_anotacao_credito_pix_recebido,
  cod_usuario,
  info_erros,
  nome,
  nome_contra_parte,
  cod_operacao,
  cpf_cnpj,
  cod_ispb_contra_parte,
  cod_agencia_contra_parte,
  nro_conta_contra_parte,
  tipo_conta_contra_parte,
  cpf_cnpj_contra_parte,
  datainsercaoctrl ,
  datainicioctrl ,
  datafimctrl ,
  dataparticaoctrl ,
  dataatualizacaoctrl,
  dt_carga_bronze dt_carga_bronze_pix_recebido
FROM  
  `corporativo-poc-hvar.bronze_bi.bi_pix_tbl_pix_anotacaocredito`
WHERE
  TIMESTAMP_TRUNC(_PARTITIONTIME, DAY) = TIMESTAMP("2024-06-27")

),
status_anotacao_credito as(
SELECT distinct
  sk_pix_statusanotacaocredito,
  end_to_end,
  status_anotacao_credito
FROM
  `corporativo-poc-hvar.bronze_bi.bi_pix_tbl_pix_statusanotacaocredito` 

 )


select 
distinct 
*
  from anotacao_credito as a
  inner join status_anotacao_credito as b
  on a.end_to_end_pix_recebido = b.end_to_end 
  ;


-- ** tbl_pix_status_anotacao_credito  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.bronze_bi.bi_pix_tbl_pix_statusanotacaocredito` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
  SK_Pix_StatusAnotacaoCredito ,
  data_hora_processamento ,
  data_hora_registro ,
  id ,
  nro_movimento ,
  id_bacen_psp_final ,
  end_to_end ,
  info_erros ,
  status_anotacao_credito ,
  campo_extra ,
  datainsercaoctrl ,
  datainicioctrl ,
  datafimctrl ,
  dataparticaoctrl ,
  dataatualizacaoctrl ,
      
      ROW_NUMBER() OVER(PARTITION BY id, data_hora_registro ORDER BY data_hora_registro DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.BI_RENDIMENTO.BI_PIX_TBL_Pix_StatusAnotacaoCredito`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.id = raw.id  
and bronze.data_hora_registro = raw.data_hora_registro  

WHEN MATCHED THEN UPDATE SET
bronze.sk_pix_statusanotacaocredito           =  raw.SK_Pix_StatusAnotacaoCredito ,
bronze.data_hora_processamento                =  raw.data_hora_processamento ,
bronze.data_hora_registro                     =  raw.data_hora_registro ,
bronze.id                                     =  raw.id ,
bronze.nro_movimento                          =  raw.nro_movimento ,
bronze.id_bacen_psp_final                     =  raw.id_bacen_psp_final ,
bronze.end_to_end                             =  raw.end_to_end ,
bronze.info_erros                             =  raw.info_erros ,
bronze.status_anotacao_credito                =  raw.status_anotacao_credito ,
bronze.campo_extra                            =  raw.campo_extra ,
bronze.datainsercaoctrl                       =  raw.datainsercaoctrl ,
bronze.datainicioctrl                         =  raw.datainicioctrl ,
bronze.datafimctrl                            =  raw.datafimctrl ,
bronze.dataparticaoctrl                       =  raw.dataparticaoctrl ,
bronze.dataatualizacaoctrl                    =  raw.dataatualizacaoctrl 

WHEN NOT MATCHED THEN INSERT (
 sk_pix_statusanotacaocredito ,
  data_hora_processamento ,
  data_hora_registro ,
  id ,
  nro_movimento ,
  id_bacen_psp_final ,
  end_to_end ,
  info_erros ,
  status_anotacao_credito ,
  campo_extra ,
  datainsercaoctrl ,
  datainicioctrl ,
  datafimctrl ,
  dataparticaoctrl ,
  dataatualizacaoctrl ,
  dt_carga_bronze
)
VALUES (
  raw.SK_Pix_StatusAnotacaoCredito ,
  raw.data_hora_processamento ,
  raw.data_hora_registro ,
  raw.id ,
  raw.nro_movimento ,
  raw.id_bacen_psp_final ,
  raw.end_to_end ,
  raw.info_erros ,
  raw.status_anotacao_credito ,
  raw.campo_extra ,
  raw.datainsercaoctrl ,
  raw.datainicioctrl ,
  raw.datafimctrl ,
  raw.dataparticaoctrl ,
  raw.dataatualizacaoctrl ,
  CURRENT_DATETIME('-03:00')
);

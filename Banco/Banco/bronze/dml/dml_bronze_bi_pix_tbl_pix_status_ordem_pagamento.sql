
-- ** tbl_pix_status_anotacao_credito  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.bronze_bi.bi_pix_tbl_pix_status_ordem_pagamento` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
sk_pix_status_ordem_pagamento ,
  data_hora_processamento ,
  data_hora_registro ,
  id ,
  id_ordem_pagamento ,
  informacao_adicional ,
  status_ordem_pagamento ,
  dataatualizacaoctrl ,
  datafimctrl ,
  datainicioctrl ,
  datainsercaoctrl ,
  dataparticaoctrl ,
      
      ROW_NUMBER() OVER(PARTITION BY id, data_hora_registro ORDER BY data_hora_processamento  DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.BI_RENDIMENTO.BI_PIX_TBL_Pix_Status_Ordem_Pagamento`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.id = raw.id   
and bronze.data_hora_registro = raw.data_hora_registro  

WHEN MATCHED THEN UPDATE SET
bronze.sk_pix_status_ordem_pagamento          = raw.sk_pix_status_ordem_pagamento ,
bronze.data_hora_processamento                = raw.data_hora_processamento ,
bronze.data_hora_registro                     = raw.data_hora_registro ,
bronze.id                                     = raw.id ,
bronze.id_ordem_pagamento                     = raw.id_ordem_pagamento ,
bronze.informacao_adicional                   = raw.informacao_adicional ,
bronze.status_ordem_pagamento                 = raw.status_ordem_pagamento ,
bronze.dataatualizacaoctrl                    = raw.dataatualizacaoctrl ,
bronze.datafimctrl                            = raw.datafimctrl ,
bronze.datainicioctrl                         = raw.datainicioctrl ,
bronze.datainsercaoctrl                       = raw.datainsercaoctrl ,
bronze.dataparticaoctrl                       = raw.dataparticaoctrl 

WHEN NOT MATCHED THEN INSERT (
 sk_pix_status_ordem_pagamento ,
  data_hora_processamento ,
  data_hora_registro ,
  id ,
  id_ordem_pagamento ,
  informacao_adicional ,
  status_ordem_pagamento ,
  dataatualizacaoctrl ,
  datafimctrl ,
  datainicioctrl ,
  datainsercaoctrl ,
  dataparticaoctrl ,
  dt_carga_bronze
)
VALUES (
  raw.sk_pix_status_ordem_pagamento ,
  raw.data_hora_processamento ,
  raw.data_hora_registro ,
  raw.id ,
  raw.id_ordem_pagamento ,
  raw.informacao_adicional ,
  raw.status_ordem_pagamento ,
  raw.dataatualizacaoctrl ,
  raw.datafimctrl ,
  raw.datainicioctrl ,
  raw.datainsercaoctrl ,
  raw.dataparticaoctrl ,
  CURRENT_DATETIME('-03:00')
);

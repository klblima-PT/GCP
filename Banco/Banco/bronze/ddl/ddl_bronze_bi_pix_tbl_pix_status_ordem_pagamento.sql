
-- ** tbl_pix_bloqueio_ordem_pagamento  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

 CREATE TABLE IF NOT EXISTS  `corporativo-poc.bronze_bi.bi_pix_tbl_pix_status_ordem_pagamento`
(
  sk_pix_status_ordem_pagamento INT64,
  data_hora_processamento DATETIME,
  data_hora_registro DATETIME,
  id INT64,
  id_ordem_pagamento INT64,
  informacao_adicional STRING,
  status_ordem_pagamento STRING,
  dataatualizacaoctrl DATETIME,
  datafimctrl DATE,
  datainicioctrl DATE,
  datainsercaoctrl DATETIME,
  dataparticaoctrl DATE,
dt_carga_bronze     DATETIME,

  PRIMARY KEY
    (id, data_hora_registro) NOT ENFORCED
)
PARTITION BY _PARTITIONDATE -- Replace by Client options sent

CLUSTER BY data_hora_registro
    

OPTIONS (
  DESCRIPTION = 'Table bi_pix_tbl_pix_status_ordem_pagamento clustered by data_hora_registro'
); 
